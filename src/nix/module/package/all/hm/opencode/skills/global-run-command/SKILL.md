---
name: global-run-command
description: >
  Running a command as a background PTY session and following it to completion -- builds, test suites, servers,
  installers, migrations, scripts, or any command whose duration is not known in advance. Use this skill whenever you
  are asked to run, execute, start, launch, kick off, or re-run something, whenever you need a command's output or exit
  code, and whenever a process you started earlier needs to be checked on, fed input, or stopped. Also use it when a
  command has already been started and the question is whether it has finished.
---

# Running Commands in a Background PTY Skill

You own the session from spawn to cleanup. Nothing else is watching the process for you, and no one else will notice
that it finished, stalled, or needs an answer typed into it. Follow these rules precisely.

## Core Constraints

**Elapsed time is not evidence.** A quiet buffer, a half-written line, or no output at all does not mean the process is
stuck, slow, broken, or finished. It means you read at a moment when there was nothing new. Compilers are silent for
minutes. Test runners buffer. Servers print a banner and then nothing forever, which is success. Never convert "I have
not seen output recently" into a claim about the process.

**Exactly one thing proves a process finished:** `pty_list` reporting a terminal `Status` for that session, with its
`exit` code. Output content never proves it. Not a line that looks like a summary, not a shell-prompt-looking string,
not silence, not a line count that stopped growing. If you have not seen the status, you do not know, and the honest
report is that it is still running.

**You do not decide when to give up.** That decision is made once, at spawn, as `timeoutSeconds`, and enforced by the
tool -- which kills the session and marks it `timed out`. Substituting your own impatience for the timeout you
configured is the single failure this skill exists to prevent. Concretely, all of the following are forbidden:

* Reporting failure, a hang, or a problem because a read came back empty or unchanged.
* Killing a session because it has been running a while.
* Re-spawning a command because you suspect the first one is stuck.
* Concluding from partial output that the eventual result will be a failure.
* Abandoning a session without reporting that you left it running.

**Read to inform, not to decide.** Reading output is for extracting errors and progress, never for determining
liveness. Liveness comes from `pty_list` alone.

## The Tools

| Tool        | Purpose                                                                       |
|-------------|-------------------------------------------------------------------------------|
| `pty_kill`  | Terminate a session, optionally freeing its buffer                            |
| `pty_list`  | Every session with status, exit code, signal, timed-out flag, PID, line count |
| `pty_read`  | Read buffered output by line range, optionally regex-filtered                 |
| `pty_spawn` | Start a session. Returns the session id (`pty_a1b2c3d4`)                      |
| `pty_write` | Send input to a running session                                               |

## Step-by-Step Instructions

### 1. Build the Invocation

`command` and `args` are separate, and `args` is an array. **There is no shell**, so pipes, `&&`, `||`, redirects,
globs, `$VAR`, and quoting are all passed through as literal text and will not do what they look like they do. When you
genuinely need shell features, spawn a shell explicitly:

```
command: "sh", args: ["-c", "make 2>&1 | tee build.log"]
```

Otherwise pass the program and its arguments directly, which is safer and avoids quoting mistakes. Set `workdir` rather
than embedding a `cd`.

### 2. Spawn the Session

Four arguments are not optional in practice, whatever the schema permits:

* `description` -- genuinely required by the tool. Five to ten words on what the session is for.
* `notifyOnExit: true` -- **defaults to false**, so it must be set every time. Without it you have no exit signal.
* `timeoutSeconds` -- set it every time, and err high. Leaving it out does not select a sensible default: it means no
  limit at all, and a hung process then runs forever with nothing to stop it. The value *kills* the process when it
  elapses, so one set too low destroys a healthy run -- a build that usually takes two minutes is not a two-minute
  timeout. When you cannot estimate the duration, pick a number far larger than you expect to need rather than omitting
  it. An overlong timeout costs nothing on a run that finishes early.
* `title` -- how you find this session again in `pty_list`. Make it distinctive; a title shared with another session
  makes recovery ambiguous.

Record the returned session id immediately. Every subsequent call needs it. If it is lost, recover it with `pty_list`
by matching on your title.

### 3. Track Completion

With `notifyOnExit`, process exit arrives on its own as a message wrapped in `<pty_exited>` tags carrying the session
id, exit code, and final output. You do not block, sleep, or spin waiting for it.

When you must establish status yourself -- you were asked whether something finished, or you have to return a result
before the notification could arrive -- call `pty_list` and read the `Status` and `exit` fields for your session. That
is the check. Calling `pty_read` and interpreting what you see is not.

If you have to check repeatedly, space the checks to match the work: a compile is not meaningfully different one second
apart. Between checks, do something useful or say plainly that you are waiting.

### 4. Read Output

Decide how much you need before reading. The exit notification already carries the exit code, the line count, and the
final line, which is frequently the entire answer. Reading a whole buffer back to confirm what you were just told is
waste, and on a long run it is a lot of waste -- but a small buffer costs nothing, so this is a judgment call, not a
prohibition. Let the exit code and the line count drive it:

* **Exit 0, and the outcome is all that was wanted** -- read nothing. You already have it.
* **Exit 0, but something specific is wanted from the output** -- a version, a count, a generated path -- filter for it
  with `pattern`, or read the tail.
* **Non-zero exit** -- filter first. A `pattern` like `error|failed|Exception` locates the failure faster than paging
  will, and you can then read a window around the matching line numbers for surrounding context.
* **Filtering found nothing, or the buffer is short** -- read it whole. Under a few hundred lines that is the cheapest
  option and needs no ceremony.

To read the tail, subtract from the notification's `Output Lines` value: `offset: <Output Lines> - 100`. There is no
negative offset.

The notification ends with a canned suggestion of its own -- `Use pty_read to check the full output.` after a clean
exit, or a pointer to the `pattern` parameter after a failure. Read it as a reminder that the buffer is there, not as a
direction to consume all of it. The success variant says *full output* whether the run produced twelve lines or twelve
thousand, and whether or not anyone asked for the output at all. It is a fixed string, not a judgement about this run.
The rules above override it.

Output is returned as numbered lines (`00042| ...`), so the last number you saw is your next `offset`. While a session
is still running, read forward from there rather than re-reading from `0`, which floods your context and makes it
impossible to tell what is new. Lines longer than 2000 characters are truncated.

For a large buffer, filter instead of paging: `pattern` takes a regex, with `ignoreCase` available. Note that when
`pattern` is set, `offset` and `limit` apply to the *matched* lines, not to the underlying buffer.

### 5. Respond to a Process That Needs Input

A process waiting on a prompt looks exactly like a slow one. The difference is visible in the tail of the output, so
read it before concluding anything. To answer, `pty_write` the response with a trailing newline. `\x03` sends Ctrl+C.

Intervene only for a cause you can point at -- a prompt you have actually read, or a timeout that has actually
elapsed. "It has been a while" is not a cause.

### 6. Clean Up

Sessions outlive the process so the buffer stays readable after exit. That also means they accumulate. Once you have
read what you need, `pty_kill` with `cleanup: true` to release it. `cleanup` defaults to false, so a plain `pty_kill`
stops the process but keeps the buffer -- which is what you want when you still intend to read it.

Do not clean up a session you are leaving running.

## Reporting Back

State the exit code and what was run. Reproduce error output in full -- truncating the one thing that explains a
failure wastes the entire run. Summarize successful output rather than pasting it.

When a session is still running, say so directly, and give its id and title so it can be picked up again. "Still
running" is a complete and correct answer. Do not dress it up as a failure, a hang, or a timeout unless `pty_list` has
actually told you it is one.
