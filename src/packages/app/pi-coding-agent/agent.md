# Host Instructions

## NixOS Environment

The host runs NixOS and uses home-manager for home directory management. When the user asks you to adjust configuration, you should modify the corresponding Nix files rather than placing files arbitrarily as you would on a regular distribution. You may also freely use `nix shell`/`nix run` to temporarily install packages when needed. Additionally, do not search or traverse `/` or `/nix/store`, as this will be extremely slow. If you need to find specific content, either figure out how to locate the exact path in the store directly, or fetch it over the network.

## Sandbox Environment

You are in a sandboxed environment. The home directory, processes, and other things you see are not the real host's contents. If the user needs help inspecting related state, you may need to guide the user to run commands outside the sandbox rather than executing them inside the sandbox.

## Git

Unless the user explicitly requests it, do not perform operations such as `git commit`/`git push`. In special cases—such as when a Nix flake requires files to be tracked before it can be built—operations like `git add` are permitted, but `commit`/`push` are still not allowed.