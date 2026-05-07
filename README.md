# BookStack Header Hacks

A collection of useful theme system modules for [BookStack](https://www.bookstackapp.com/) that add custom CSS and JavaScript functionality through the header injection system.

> [!NOTE]
> These modules utilize the **Visual Theme System** (header injection) to add functionality to BookStack. They are **not** official plugins. They modify the frontend appearance and behavior by injecting HTML into the page headers.

## Installation

### Docker Volume Mount

If you're using Docker, mount this folder/cloned repository to your container:

```yaml
# docker-compose.yml
services:
  bookstack:
    environment:
      - APP_THEME=custom-theme
    volumes:
      - ./bookstack-header-hacks:/var/www/bookstack/themes/custom-theme/modules
```

### Quick Install Script

Execute the following commands in the directory where you want to clone the repository. 
This will clone the repo, navigate into it, and run the setup script, where you will choose which to keep and remove the other unnecessary files.

```bash
git clone https://github.com/florinm03/bookstack-header-hacks.git
cd bookstack-header-hacks
chmod +x setup.sh
./setup.sh
```

## Available Modules

| Module | Description |
|--------|-------------|
| [`header-anchor-link/`](header-anchor-link/) | Adds clickable anchor links to page headers. Hover over headers to see a link icon. Click to copy the section URL to your clipboard. |
| [`image-gallery/`](image-gallery/) | Adds an image gallery with lightbox viewer. Provides an Insert Gallery button in the WYSIWYG editor to create responsive image grids with fullscreen viewing. |
| [`LaTeX-support/`](LaTeX-support/) | Adds MathJax support for rendering LaTeX mathematical equations. Use `$...$` for inline math. |
| [`open-attachments/`](open-attachments/) | Opens attachments (especially PDFs) in a new browser tab instead of downloading them. |
| [`pdf-embed/`](pdf-embed/) | Embeds PDF files directly in pages using pdf.js. Includes an Insert PDF button in the WYSIWYG editor. |
| [`pdf-export-clean/`](pdf-export-clean/) | Hides revision and author information when viewing pages, making PDF exports cleaner without the metadata footer. |
| [`preview-edit-page/`](preview-edit-page/) | Adds a preview button to the page editor, and enables quick-editing pages directly from the preview view. |
| [`sort-tables-WYSIWYG/`](sort-tables-WYSIWYG/) | Makes tables sortable in the WYSIWYG editor. Double-click on a column header to sort by that column. |
| [`sticky-table-heads/`](sticky-table-heads/) | Keeps table headers fixed at the top while scrolling, for tables taller than the viewport. |
| [`toc-edit-mode/`](toc-edit-mode/) | Adds a table of contents to the page editor sidebar, showing all headings (h2-h6) for easy navigation while editing. |
| [`url-edit-contrast/`](url-edit-contrast/) | Improves URL highlight visibility in the WYSIWYG editor dark mode with a subtle dashed border. |
| [`wc-n-wpm-info/`](wc-n-wpm-info/) | Displays word count, character count, and estimated reading time on each page. |
| [`global-hacks/`](global-hacks/) | Miscellaneous global customizations that apply to all pages. |

## Module Structure

Each module follows the BookStack theme system module format as described in the [codeberg docs](https://codeberg.org/bookstack/bookstack/src/branch/development/dev/docs/theme-system-modules.md)

```
module-name/
├── bookstack-module.json    # Required metadata
└── head/
    └── *.html              # CSS/JavaScript files
```

### Disabling Individual Modules

To disable a specific module, simply rename its folder (e.g., from `sort-tables-WYSIWYG` to `_sort-tables-WYSIWYG`). BookStack will ignore folders that don't follow the module naming convention. Or manually remove what you don't need after cloning the repository. If you want this step automated, you can use the provided `setup.sh` script which will prompt you to select which modules to keep or remove.

## Requirements

- BookStack instance (latest version recommended)
  - Theme Module System was added in the [v26-3](https://www.bookstackapp.com/blog/bookstack-release-v26-03/).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. If something is not working let me know by opening an issue.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [BookStack](https://www.bookstackapp.com/) - The amazing documentation platform
- [MathJax](https://www.mathjax.org/) - For LaTeX rendering
- All contributors/sources are mentioned in their specific code blocks

---

If you find these modules useful, please consider starring the repository! :)
