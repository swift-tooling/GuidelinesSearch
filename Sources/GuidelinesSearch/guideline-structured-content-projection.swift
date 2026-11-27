import DSL

public enum GuidelineStructuredContentProjection {
    public static func isEmpty(
        _ content: StructuredContent
    ) -> Bool {
        text(content).allSatisfy {
            $0.isWhitespace
        }
    }

    public static func text(
        _ content: StructuredContent
    ) -> String {
        switch content {
        case .collection(let content):
            return joined(
                content.map(text)
            )

        case .paragraph(let content):
            return text(content)

        case .code(
            _,
            let source
        ):
            return source

        case .quote(
            let content,
            let attribution
        ):
            return joined([
                text(content),
                attribution.map(text) ?? "",
            ])

        case .figure(
            _,
            let content,
            let caption
        ):
            return joined([
                text(content),
                caption.map(text) ?? "",
            ])

        case .verse(let lines):
            return joined(
                lines.map(text)
            )

        case .rule:
            return ""

        case .list(
            _,
            let items
        ):
            return joined(
                items.map(text)
            )

        case .group(
            _,
            let title,
            let content
        ):
            return joined([
                title.map(text) ?? "",
                text(content),
            ])

        case .table(
            let header,
            let rows
        ):
            return joined(
                ([header] + rows).flatMap {
                    $0.map(text)
                }
            )

        case .heading(
            _,
            _,
            let content
        ):
            return text(content)

        case .image(
            _,
            let alt
        ):
            return alt

        case .definitions(let definitions):
            return joined(
                definitions.flatMap {
                    [
                        text($0.term),
                        text($0.description),
                    ]
                }
            )

        case .listing:
            return ""

        case .notes(let notes):
            return joined(
                notes.map { text($0.content) }
            )

        case .native(
            _,
            _,
            let fallback
        ):
            return text(fallback)
        }
    }

    private static func text(
        _ content: [StructuredContent.Inline]
    ) -> String {
        content
            .map(text)
            .joined()
    }

    private static func text(
        _ content: StructuredContent.Inline
    ) -> String {
        switch content {
        case .text(let content),
             .code(let content):
            return content

        case .emphasis(let content),
             .strong(let content),
             .link(_, let content):
            return text(content)

        case .citation:
            return content.plainText

        case .footnote(let footnote):
            return text(footnote)

        case .noteReference:
            return ""
        }
    }

    private static func joined(
        _ content: [String]
    ) -> String {
        content
            .filter {
                !$0.isEmpty
            }
            .joined(
                separator: "\n"
            )
    }
}
