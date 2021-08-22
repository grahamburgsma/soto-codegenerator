extension Templates {
    static let paginatorAsyncTemplate = #"""
    {{%CONTENT_TYPE:TEXT}}
    {{>header}}

    #if compiler(>=5.5) && $AsyncAwait

    import SotoCore

    // MARK: Paginators

    @available(macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, *)
    extension {{name}} {
    {{#paginators}}
    {{#operation.comment}}
        ///  {{.}}
    {{/operation.comment}}
        /// Return PaginatorSequence for operation.
        ///
        /// - Parameters:
        ///   - input: Input for request
        ///   - logger: Logger used flot logging
        ///   - eventLoop: EventLoop to run this process on
    {{#operation.deprecated}}
        @available(*, deprecated, message:"{{.}}")
    {{/operation.deprecated}}
        public func {{operation.funcName}}Paginator(
            _ input: {{operation.inputShape}},
            logger: {{logger}} = AWSClient.loggingDisabled,
            on eventLoop: EventLoop? = nil
        ) -> AWSClient.PaginatorSequence<{{operation.inputShape}}, {{operation.outputShape}}> {
            return .init(
                input: input,
                command: {{operation.funcName}},
    {{#inputKey}}
                inputKey: \{{operation.inputShape}}.{{.}},
    {{/inputKey}}
                outputKey: \{{operation.outputShape}}.{{outputKey}},
    {{#moreResultsKey}}
                moreResultsKey: \{{operation.outputShape}}.{{.}},
    {{/moreResultsKey}}
                logger: logger,
                on: eventLoop
            )
        }
    {{^last()}}

    {{/last()}}
    {{/paginators}}
    }

    #endif // compiler(>=5.5) && $AsyncAwait
    """#
}
