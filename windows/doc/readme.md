# cppman (Windows-Compatible Fork)

This is a Windows-adapted fork of the original [cppman](https://github.com/aitjcize/cppman) project.

This fork focuses on **maximum compatibility with the Windows environment**, ensuring native functionality without relying on Unix-like tools or environments (e.g., WSL or Cygwin).

---

## Key Features

- Fully compatible with native Windows terminals
- Supports custom pager scripts via `pager.cmd` (replacement for original `pager.sh`)
- Optional included support `bat` as pagers

---

## Installation

1. Clone this repository or download it as a `.zip`:

```bash
git clone https://github.com/bcrment/cppman.git
cd cppman/windows
````

2. Run the main interface:

```bash
python run.py <search>
```
`or`
```bash
cppman.cmd <search> 
```

---

## Usage Examples

```bash
python run.py --help  # For help 
python run.py printf  # View C++ manpage for printf
```

---

## Pager System on Windows

This fork replaces the original `pager.sh` with a Windows-compatible `pager.cmd`.

* `vim` (with `cppman.vim` integration)
* `nvim`
* `less`
* `bat`
* Default fallback to `more` or raw output

You can manually set the pager via:

```bash
python run.py --pager less
```

---

## Important Notes

* This fork is intended for **native Windows usage**
* All adaptations maintain full respect to the original licensing (GPL v3).

---

## License

This project retains the original [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

---

## Credits

Thanks to the original contributors of `cppman`. This fork aims only to extend the tool’s accessibility to the Windows ecosystem with minimal changes to core logic.

Original author: [Wei-Ning Huang (AZ)](https://github.com/aitjcize)

Windows compatibility fork by: **Bruno C. Rodrigues**

```
