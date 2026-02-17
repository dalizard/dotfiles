# ABOUTME: Overrides Homebrew's vendor mise-activate.fish to prevent double activation.
# ABOUTME: Mise is activated in config.fish after Homebrew PATH setup for correct PATH order.
#
# Homebrew installs a vendor conf.d script that auto-activates mise:
#   /opt/homebrew/share/fish/vendor_conf.d/mise-activate.fish
#
# Fish uses basename precedence when loading conf.d files — if a user conf.d
# file has the same basename as a vendor one, only the user version is sourced.
# This file exists solely to shadow that vendor script.
#
# Why: fish loads conf.d before config.fish. The vendor script would activate
# mise before config.fish adds Homebrew to PATH. Then config.fish:
#   1. Prepends /opt/homebrew/bin to PATH (pushing mise tool paths down)
#   2. Runs mise activate again, but hook-env sees no changes — no-op
# Result: /opt/homebrew/bin/go wins over mise's go.
#
# By blocking the vendor activation, mise activates only once from config.fish,
# after Homebrew is in PATH. hook-env then prepends tool paths before Homebrew.
