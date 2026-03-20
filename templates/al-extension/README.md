# AL Extension Template

Starter template for a Microsoft Dynamics 365 Business Central AL extension.

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [AL Language extension](https://marketplace.visualstudio.com/items?itemName=ms-dynamics-smb.al)
- Access to a Business Central sandbox environment or Docker container

## Quick Start

1. **Clone / copy** this template into your project folder.
2. **Update `app.json`:**
   - Replace the `id` GUID with a new unique GUID.
   - Set `name`, `publisher`, `version`, and `description`.
   - Adjust `dependencies` versions to match your BC version.
   - Set your `idRanges` to a range you own.
3. **Open in VS Code** and run `AL: Download Symbols` (`Ctrl+Shift+P`).
4. **Build** with `Ctrl+Shift+B`.

## Project Structure

```
.
├── app.json                        # Extension manifest
├── HelloWorld.Page.al              # Sample page object
├── HelloWorldTest.Codeunit.al      # Sample test codeunit
├── Translations/                   # (create) XLIFF translation files
└── .gitignore
```

## ID Ranges

The template uses the range **50000–50099** as a placeholder. Update this to your licensed range before publishing to AppSource or a production environment.

## Versioning

Follow the `Major.Minor.Build.Revision` format in `app.json`. Use tags (`v1.0.0.0`) with the `al-release.yml` GitHub Actions workflow to automate releases.

## Resources

- [AL Developer Docs](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-dev-overview)
- [BcContainerHelper](https://github.com/microsoft/navcontainerhelper)
- [Business Central on GitHub](https://github.com/microsoft/BCApps)
