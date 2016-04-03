# Environment Configuration

## Installation

If using [Homebrew][homebrew] or [Linuxbrew][linuxbrew]:

```
$ brew install elixir
```

Or [Chocolatey NuGet][chocolatey]:

```
C:\> choco install elixir
```

> Needing another method for installing Elixir? Consult [the install documentation][elixir-docs-install] on the Elixir website.

During the installation, your package manager of choice will download and install both Elixir and Erlang, the underlying system Elixir uses to get a fair amount of its features, plus any other dependencies that may not be installed on your system. This process could take a considerable amount of time if your package manager cannot find pre-built executables for Elixir and Erlang, but in most cases, it should be a quick process.

Once installed, verify your environment has the Elixir executables on its `PATH` with `elixir --version`, `iex --version`, and `mix --version`:

> These should all report the same version number.

```
$ elixir --version
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [async-threads:10] [kernel-poll:false]

Elixir 1.2.0
$ iex --version
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [async-threads:10] [kernel-poll:false]

IEx 1.2.0
$ mix --version
Mix 1.2.0
```

### What are these executables?

Elixir and Erlang come with a set of executable files for working with the Elixir, Erlang, and the Erlang virtual machine (VM), also known as the Bogdan/Björn’s Erlang Abstract Machine (BEAM):

- `elixir`: Allows Elixir and/or BEAM files to be ran against the VM. Corresponds to Erlang's `erl_call`
- `elixirc`: Compiles Elixir files to BEAM bytecode. Corresponds to Erlang's `erlc`
- `mix`: Elixir's default build tool
- `iex`: Interactive Elixir, Elixir's REPL. Corresponds to Erlang's `erl`

We will be using `mix` and `iex` in most cases. Mix commands wrap `elixir` and `elixirc` when appropriate, so interfacing with them directly is not necessary at all times.

> ### An aside: Docker
>
> Don't want to install Elixir to your machine but have Docker available? You can use a Docker continer to house your Elixir installation:
>
> ```
> $ docker pull elixir
> $ docker run -it --rm -h elixir.local elixir elixir --version
> Erlang/OTP 18 [erts-7.3] [source] [64-bit] [async-threads:10] [hipe] [kernel-poll:false]
>
> Elixir 1.2.4
> $ docker run -it --rm -h elixir.local elixir iex --version
> Erlang/OTP 18 [erts-7.3] [source] [64-bit] [async-threads:10] [hipe] [kernel-poll:false]
>
> IEx 1.2.4
> $ docker run -it --rm -h elixir.local elixir mix --version
> Mix 1.2.4
> ```
>
> Using Docker can increase the complexity of using Elixir, so only use it if you *really* have a reason. We're going to proceed using a locally-installed version of Elixir.

[homebrew]: http://brew.sh/
[linuxbrew]: http://linuxbrew.sh/
[chocolatey]: https://chocolatey.org/
[elixir-docs-install]: http://elixir-lang.org/install.html

## Mix commands

Packaged with the Elixir standard installation, Mix is a build tool that provides tasks for creating, compiling, testing Elixir projects, as well as handle dependencies, and more. Here are a few fairly common Mix commands:

| Command        | Description                           |
|----------------|---------------------------------------|
| `mix`          | Runs the default task                 |
| `mix compile`  | Compiles source files                 |
| `mix deps.get` | Gets all out of date dependencies     |
| `mix do`       | Executes the tasks separated by comma |
| `mix new`      | Creates a new Elixir project          |
| `mix run`      | Runs the given file or expression     |
| `mix test`     | Runs a project's tests                |

> Find an entire list of commands with the Mix command `mix help`.

Mix and Elixir provide a set of default and pre-installed Mix commands, but more can be provided through Mix archives and project dependencies. We'll be exploring these and other Mix commands in later chapters.

## Editor development tools

Most popular editors have at least some support for Elixir, from basic language/syntax support to deeper code introspection. While the below are a couple useful packages for Emacs and Vim, this is only a small portion of an ever-growing list of Elixir's editor and IDE support.

### Emacs

- [emacs-elixir][emacs-elixir] - Basic language support
- [alchemist.el][alchemist-el] - All around Elixir tooling

### Vim

- [vim-elixir][vim-elixir] - Basic language support
- [alchemist.vim][alchemist-vim] - Based on alchemist.el's `alchemist-server` abstraction

[emacs-elixir]: https://github.com/elixir-lang/emacs-elixir
[alchemist-el]: https://github.com/tonini/alchemist.el
[vim-elixir]: https://github.com/elixir-lang/vim-elixir
[alchemist-vim]: https://github.com/slashmili/alchemist.vim

## Summary

