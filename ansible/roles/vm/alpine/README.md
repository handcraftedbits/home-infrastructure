# vm/alpine

An [Ansible](https://www.ansible.com) role used to create an [Alpine](https://alpinelinux.org)-based VM.

# Usage

Provide a variable named `vm_alpine_params` of type [`vm_alpine_params`](#vm_alpine_params) when including/depending on
this role.

# Types

## `vm_alpine_params`

The parameters for this role.

### Schema

```yaml
esxi_server:
iso:
keyboard:
  layout:
  variant:
timezone:
vm_settings:
```

| Name               | Type                                                 | Required? | Description                                                                                                                                                       |
|--------------------|------------------------------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `esxi_server`      | [`esxi_server`](../../esxi/vm/README.md#esxi_server) | **yes**   | ESXi server information.                                                                                                                                          |
| `iso`              | `string`                                             | no        | The path to the ISO image used to install the VM.                                                                                                                 |
| `keyboard.layout`  | `string`                                             | no        | The keyboard layout to use, as defined by [`setup-keymap`](https://beta.docs.alpinelinux.org/user-handbook/0.1a/Installing/manual.html#_keyboard_layout).         |
| `keyboard.variant` | `string`                                             | no        | The keyboard layout variant to use, as defined by [`setup-keymap`](https://beta.docs.alpinelinux.org/user-handbook/0.1a/Installing/manual.html#_keyboard_layout). |
| `timezone`         | `string`                                             | no        | The timezone to use, as defined by [`setup-timezone`](https://beta.docs.alpinelinux.org/user-handbook/0.1a/Installing/manual.html#_timezone).                     |
| `vm_settings`      | [`vm_settings`](../../esxi/vm/README.md#vm_settings) | no        | The VM settings to use.                                                                                                                                           |
