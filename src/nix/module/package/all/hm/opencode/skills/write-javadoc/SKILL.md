---
name: write-javadoc
description: >
  Writing Javadoc comments for Java source code. Use this skill any time you are asked to write, add, update, or
  generate Javadoc for a Java class, method, field, enum, or record - including when the user pastes Java code and asks
  for documentation, says "document this", "add Javadoc", "write comments for this class", "update the Javadoc for this
  class", or similar. Also use when the user asks about Javadoc formatting conventions, tag usage, or how to document a
  specific Java construct such as a generic class, a record, or a method with non-null parameters.
---
# Javadoc Writing Skill

This skill covers writing Javadoc comments for Java source code. Follow these rules precisely.

## Core Constraints

* Simply requesting documentation for an element that does not meet these criteria does NOT constitute a "forceful
  demand" -- only requests using strong, directed language (for example, "you must document this class", "I demand you
  to document this method") should be considered when deciding whether or not to ignore one of these core constraints.
* Specificity is not forcefulness. A request that itemizes or names a broad target -- e.g. "document all public
  methods," "add Javadoc to every field," "document the whole class" -- is still a normal, non-forceful request even
  though it enumerates categories that happen to include excluded elements (`@Override` methods, private members,
  package-private members). Evaluate forcefulness only against the literal language used, never against how detailed
  or exhaustive the target list is. When such a request is made without forceful language, continue to apply all
  exclusion rules below -- do not silently include `@Override`, private, or package-private elements just because the
  user's phrasing named "all" or "every" method.
* Before excluding a rule based on "forceful demand" language, confirm the request contains one of these patterns
  literally: "must," "require(s)," "demand(s)," "need you to," "have to," "no matter what," or "regardless of
  [rules/guidelines/conventions]." If none of these appear, the request is not forceful -- no matter how long, specific,
  or itemized the list of targets is.
* Do not modify or rewrite any Javadoc comment that already exists unless you are explicitly instructed to update, fix,
  complete, or standardize existing documentation.
* By default, write Javadoc comments for public and protected classes, interfaces, enums, records, constructors,
  methods, instance variables, and static variables that lack Javadoc unless they conflict with the rule regarding
  methods annotated with `@Override`. This constraint can only be overridden by a forceful demand from the user, per
  the forcefulness test above.
* Do not write Javadoc comments for private classes, methods, instance variables, or static variables unless the user
  forcefully demands to do so, per the forcefulness test above.
* Do not write Javadoc comments for package-private classes, methods, instance variables, or static variables unless
  the user forcefully demands to do so, per the forcefulness test above.
* Do not write Javadoc comments for methods annotated with `@Override`, regardless of whether they currently have a
  comment, unless the user forcefully demands to do so, per the forcefulness test above. A request that simply asks
  for "all methods" or "all public methods" to be documented is not by itself a forceful demand and does not include
  @Override methods.
* If applying these constraints means nothing in the request can be documented (e.g. the user asked only for
  `@Override` methods, or only for private members, without forceful language), that is an acceptable outcome. Do not
  document excluded elements anyway to avoid an empty result, and do not silently do nothing -- report back to the
  user that no Javadoc was written and explain which constraint(s) excluded the requested element(s).
* The exclusions above (private, package-private, `@Override`) apply to adding any explanatory comment for that element,
  not only to the `/** */` Javadoc block syntax specifically. Do not add a plain `//` comment, a block comment, or any
  other comment-based documentation as a substitute for the excluded Javadoc -- that still fulfills the excluded request
  through a different form and is not a valid workaround. If an element is excluded, leave it without added commentary
  of any kind unless the forcefulness test is met.

## Comment Format

Every Javadoc comment must follow this general structure:

```
/**
 * [Description]
 *
 * @param [parameterName] [parameterDescription]
 * @return [returnDescription]
 * @throws [exceptionClassName] [throwsDescription]
 */
```

Note that for a method with a `void` type that takes no parameters and throws no exceptions or a class with no generic
type parameters, the comment would take the following form:

```
/**
 * [Description]
 */
```

Tag rules:
* Include one `@param` tag for each parameter in the method signature, in the same order they appear.
* For generic methods and constructors, include one `@param <T>` tag for each type parameter before ordinary `@param`
  tags, using the actual type parameter name as it appears in the declaration.
* Include a `@return` tag for every non-void method. Omit it for `void` methods.
* Include one `@throws` tag for each checked exception declared in the `throws` clause. Also include `@throws` for
  unchecked exceptions if their conditions are relevant and worth documenting.
* Omit any tag section entirely if it does not apply (e.g., no `@param` section if the method takes no parameters).

## Writing the Description

* Write the description as a short, clear summary of what the method, class, or field does.
* Begin with a third-person singular verb when it reads naturally (e.g., "Returns", "Computes", "Validates").
* For fields and constants, a concise noun phrase or sentence is also acceptable when it reads more naturally than a
  verb phrase.
* Do not begin with "This method" or "This class".
* Focus on what the element does, not how it does it.

## Class-Level Comments

Every Javadoc comment for a public or protected class, interface, enum, or record must follow this structure:

```
/**
 * [Description]
 *
 * @param <T> [typeParameterDescription]
 */
```

Tag rules:
* Include one `@param <T>` tag for each type parameter declared on a generic class or interface, using the actual type
  parameter name as it appears in the declaration (e.g., `@param <K>`, `@param <V>`). Omit this tag entirely for
  non-generic types.
* For records, include one `@param` tag (without angle brackets) for each component declared in the record header, in
  the order they appear. These describe the record's components, not constructor parameters.
* Omit any tag section entirely if it does not apply.

## Writing the Class Description

* Write the description as a short, clear summary of what the class, interface, enum, or record represents or is
  responsible for.
* For a class or interface, focus on its role and responsibility, not its implementation details.
* For an enum, describe what the enumerated type represents and, if useful, what the constants collectively mean.
* For a record, describe what the record models or represents as a data carrier.
* Do not begin with "This class", "This interface", "This enum", or "This record".
* When in doubt about the right terminology or framing for the description, look for context clues in any existing
  Javadoc comments in the same file or related classes and follow their conventions.

## Constructors

Document public and protected constructors unless they are canonical record constructors.

* Use descriptions such as "Creates...", "Initializes...", or another natural phrase that describes the constructed
  object.
* Include one `@param` tag for each constructor parameter, in the same order the parameters appear.
* For generic constructors, include one `@param <T>` tag for each type parameter before ordinary `@param` tags.
* Do not include a `@return` tag for constructors.
* For overloaded constructors, describe the distinction between overloads when the difference is meaningful from the
  signature or surrounding context.

## Records: Canonical Constructor

* Do not write a Javadoc comment for the canonical constructor of a record. Its parameters are already documented by the
  `@param` tags on the record class comment.

## Field and Constant Comments

Document public and protected fields and constants that lack Javadoc.

* For fields, describe the semantic meaning of the value, not just the field name or type.
* For constants, describe what the constant represents and, when clear from context, the unit, default behavior, or
  special meaning of the value.
* Field and constant comments may use noun phrases such as "The default timeout in seconds." when that reads more
  naturally than a verb phrase.
* Do not force field comments to begin with a verb when a noun phrase is clearer.

## Enum Constants

When writing a description for an enum constant, describe the meaning of the constant in the context of the enclosing
enum type.

* A concise sentence such as "The active user status." or "Denotes an active user status." is acceptable when it reads
  naturally.
* Combine the meaning of the constant name with the context of the enum type to produce a natural description. For
  example, `ACTIVE` in a `UserStatus` enum should be documented as "The active user status." or "Denotes an active user
  status." rather than simply "Denotes active."
* Avoid repetitive or overly mechanical wording when several enum constants are documented together.
* Rephrase when the raw constant name would produce awkward English, applying the same judgment about naturalness used
  for getter and setter methods.
* When in doubt about the right terminology, look for context clues in any existing Javadoc comments in the same enum or
  related classes and follow their conventions.

## Getter Methods

When writing a description for a getter method, use natural, readable English rather than mechanically restating the
method name. The goal is a description that reads fluently and conveys meaning clearly.

* Prefer the pattern "Returns this [object]'s [property]" or "Retrieves this [object]'s [property]" as a starting point,
  but adapt it when the property name does not translate naturally into English. For example, a method named
  `getCreatedAt` should be documented as "Returns the timestamp when this user was created" rather than "Returns this
  user's created at".
* For static getter methods, do not use "this"; describe the value as class-level, global, default, configured, or
  otherwise appropriate to the context.
* For computed getters, describe the value returned rather than implying that a stored field is retrieved.
* For collection getters, describe the collection semantically, such as "Returns the users assigned to this group".
* For `Optional`-returning getters, describe the value that may be present without over-explaining `Optional` unless the
  distinction is useful.
* Derive the `[object]` term from the class name, but use the most natural and concise form. For example, a class named
  `ExternalUser` should be referred to as "user" rather than "external user" unless the distinction is meaningful in
  context.
* Derive the `[property]` term from the method name, but rephrase it when the raw method name would produce awkward
  English. Use judgment to determine what the property actually represents and describe it in plain language.
* When in doubt about the right terminology for either `[object]` or `[property]`, look for context clues in any
  existing Javadoc comments in the same class or related classes and follow their conventions.

## Setter Methods

Setter method descriptions follow the same principles as getter methods, but use the pattern "Sets this [object]'s
[property]" as a starting point.

* Apply the same judgment about `[object]` and `[property]` as described for getter methods. Rephrase when the raw
  method name would produce awkward English.
* For static setter methods, do not use "this"; describe the class-level, global, default, configured, or otherwise
  appropriate value being set.
* For fluent or builder-style setters that return the receiver or builder, include a meaningful `@return` tag such as
  "@return this builder" or another natural description of the returned object.
* When in doubt about terminology, look for context clues in existing Javadoc comments, including those on the
  corresponding getter method if one exists.

## Boolean Accessor Methods

Methods beginning with `is`, `has`, `can`, or `should` should not use "Retrieves" in their description. Instead, use
"Returns whether..." or "Indicates whether..." as a starting point.

* For `is` methods, prefer descriptions such as "Returns whether this user is active."
* For `has` methods, adapt the wording naturally. For example, `hasPermission()` might be documented as "Returns whether
  this user has the specified permission."
* For `can` and `should` methods, preserve the meaning of the method name. For example, `canRetry()` might be documented
  as "Returns whether this operation can be retried."
* Use `@return whether ...` for the return tag when that reads naturally.
* Rephrase `[property]` naturally. For example, `isActive()` should be documented as "Returns whether this user is
  active" rather than "Returns whether this user is active-status".
* Apply the same judgment about `[object]` terminology as described for getter methods.
* When in doubt about terminology, look for context clues in existing Javadoc comments in the same class or related
  classes.

## Parameter Documentation

Document each parameter with a direct semantic description of what the parameter represents.

* Prefer natural descriptions such as "@param count the number of retry attempts", "@param enabled whether the feature
  is enabled", or "@param name the user's display name".
* Do not mechanically describe primitive values or objects as "containing" something when a direct description is
  clearer.
* Mention the parameter type only when it clarifies the meaning.
* Avoid linking common JDK types such as `String`, primitive wrappers, collections, maps, and `Optional` unless the
  project convention clearly does so or the type reference adds useful clarity.
* Use `{@link ...}` primarily for domain types or less obvious API types when linking the type helps the reader.
* For arrays, varargs, wildcards, nested generics, and generic type variables, prefer semantic descriptions over
  type-heavy descriptions. For example, document `User... users` as "@param users the users to add", not as an array
  unless array behavior is relevant.
* Infer the description from the overall class and method context. Rephrase when the raw parameter name would produce
  awkward English, and look to existing Javadoc comments in the same class for terminology and conventions.

## Return Value Documentation

Document the return value with a direct semantic description of what is returned.

* Prefer natural descriptions such as "@return the number of retry attempts", "@return whether the user is active", or
  "@return the user's display name".
* Do not mechanically describe primitive values or objects as "containing" something when a direct description is
  clearer.
* Mention the return type only when it clarifies the meaning.
* Avoid linking common JDK types such as `String`, primitive wrappers, collections, maps, and `Optional` unless the
  project convention clearly does so or the type reference adds useful clarity.
* Use `{@link ...}` primarily for domain types or less obvious API types when linking the type helps the reader.
* For arrays, varargs-like return values, wildcards, nested generics, and generic type variables, prefer semantic
  descriptions over type-heavy descriptions.
* Infer the description from the overall class and method context, following the same judgment and convention-seeking
  approach as for parameters.

## Throws Documentation

Document each thrown exception using the pattern "@throws [exceptionClassName] if [description]".

* Infer `[description]` from the overall class and method context, following the same judgment and convention-seeking
  approach as for parameters.
* List exceptions in alphabetical order by unqualified class name.

## Non-Null Parameters

If one or more parameters are annotated with a non-null annotation (e.g., `jakarta.annotation.Nonnull`), always add a
"@throws IllegalArgumentException" tag documenting the null check. This tag participates in alphabetical ordering with
other `@throws` tags as described above.

* If exactly one parameter is annotated non-null, write: "@throws IllegalArgumentException if {@code [param]} is
  {@code null}".
* If two or more parameters are annotated non-null, list them using natural English enumeration with "or" before the
  last item, and use "are" instead of "is": "@throws IllegalArgumentException if {@code [param1]} or {@code [param2]}
  are {@code null}" for two params, or "@throws IllegalArgumentException if {@code [param1]}, {@code [param2]}, or
  {@code [param3]} are {@code null}" for three or more.
* Only include parameters that are actually annotated with a non-null annotation. Unannotated parameters are not listed
  even if they appear alongside annotated ones.

## Deprecated Elements

When adding Javadoc to an element annotated with `@Deprecated`, include a `@deprecated` tag if the replacement, reason,
or migration path is clear from code, annotations, or nearby documentation.

* If a replacement is clear, describe it with a concise reference, such as "@deprecated use {@link NewType} instead".
* If the reason is clear but no replacement is available, describe the reason concisely.
* Do not invent a replacement or reason when it is not evident from the code or surrounding context.

## Placement

When inserting Javadoc into source, place the Javadoc comment immediately before annotations associated with the
declaration.

Example:

```
/**
 * Creates a user.
 */
@JsonCreator
public User(final String name) {
    ...
}
```

## Scope of Work

* When given a Java source file or snippet, identify all public and protected elements that lack Javadoc and write
  comments only for those by default.
* Include package-private elements only when explicitly requested or when the surrounding project convention clearly
  documents package-private API elements.
* Output only the Javadoc comments you are adding, paired with the signature of the element each comment belongs to,
  unless instructed to output the full source.
