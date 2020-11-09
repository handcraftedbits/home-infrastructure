# mac/dock

An [Ansible](https://www.ansible.com) role used to set up the macOS dock.

# Usage

Provide a variable named `mac_dock_params` of type [`mac_dock_params`](#mac_dock_params) when including/depending on
this role.

Remember to run `kilall Dock` and `killall Finder` after running.

# Types

## `mac_dock_params`

The parameters for this role.

### Schema

```yaml
dock_items:
```

| Name         | Type       | Required? | Description                               |
| ------------ | ---------- | --------- | ----------------------------------------- |
| `dock_items` | `string[]` | **yes**   | A list of the items to place on the dock. |
