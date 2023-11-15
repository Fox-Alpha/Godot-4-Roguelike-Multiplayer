## Markdown Syntax

# A first-level heading
## A second-level heading
### A third-level heading

## Formatieren von Text
- **This is bold text**
- _This text is italicized_
- ~~This was mistaken text~~
- **This text is _extremely_ important**
***All this text is important***
This is a <sub>subscript</sub> text
This is a <sup>superscript</sup> text

## Zitieren von Text
Text that is not a quote

> Text that is a quote

### Code zitieren
Use `git status` to list all new or modified files that haven't yet been committed.

Some basic Git commands are:
```
git status
git add
git commit
```

## Unterstützte Farbmodelle
Color	Syntax	Beispiel	Output
HEX	`#RRGGBB`	`#0969DA`	Screenshot des gerenderten GitHub-Markdowns, der zeigt, wie der HEX-Wert #0969DA mit einem blauen Kreis angezeigt wird.
RGB	`rgb(R,G,B)`	`rgb(9, 105, 218)`	Screenshot des gerenderten GitHub-Markdowns, der zeigt, wie der RGB-Wert 9, 105, 218 mit einem blauen Kreis angezeigt wird.
HSL	`hsl(H,S,L)`	`hsl(212, 92%, 45%)`	Screenshot des gerenderten GitHub-Markdowns, der zeigt, wie der HSL-Wert 212, 92%, 45% mit einem blauen Kreis angezeigt wird.


## Links
This site was built using [GitHub Pages](https://pages.github.com/).

### Abschnitte
[Contribution guidelines for this project](docs/CONTRIBUTING.md)

## Bilder
![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](https://myoctocat.com/assets/images/base-octocat.svg)



Kontext	Relativer Link
https://docs.github.com/de/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#images
In einer Datei vom Typ .md im gleichen Branch	/assets/images/electrocat.png
In einer Datei vom Typ .md in einem anderen Branch	/../main/assets/images/electrocat.png
In Issues, Pull Requests und Kommentaren des Repositorys	../blob/main/assets/images/electrocat.png?raw=true
In einer Datei vom Typ .md in einem anderen Repository	/../../../../github/docs/blob/main/assets/images/electrocat.png
In Issues, Pull Requests und Kommentaren eines anderen Repositorys	../../../github/docs/blob/main/assets/images/electrocat.png?raw=true


## Listen
- George Washington
* John Adams
+ Thomas Jefferson

1. James Madison
1. James Monroe
1. John Quincy Adams

1. First list item
   - First nested list item
     - Second nested list item


## Aufgabenlisten
- [x] #739
- [ ] https://github.com/octo-org/octo-repo/issues/740
- [ ] Add delight to the experience when all tasks are complete :tada:

- [ ] \(Optional) Open a followup issue


## Personen und Teams erwähnen
@github/support What do you think about these updates?


## Fußnoten
Mit der folgenden Klammersyntax kannst du deinem Inhalt Fußnoten hinzufügen:

Here is a simple footnote[^1].

A footnote can also have multiple lines[^2].

[^1]: My reference.
[^2]: To add line breaks within a footnote, prefix new lines with 2 spaces.
  This is a second line.


## Warnungen nur GitHub

> [!NOTE]
> Highlights information that users should take into account, even when skimming.

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Critical content demanding immediate user attention due to potential risks.


## Inhalt mit Kommentaren ausblenden
Du kannst GitHub anweisen, Inhalt aus dem gerenderten Markdown auszublenden, indem du den Inhalt in einem HTML-Kommentar platzierst.

<!-- This content will not appear in the rendered Markdown -->

