-- lazy.nvim itself is placed under its own plugin root from nixpkgs, without git metadata. Marking it virtual makes lazy.nvim treat it as
-- user-managed instead of asserting on that metadata when it writes the lockfile.
return {
  "folke/lazy.nvim",
  virtual = true,
}
