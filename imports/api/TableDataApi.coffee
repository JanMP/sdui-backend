class TableDataApi
  constructor: (@sourceName, @sourceSchema, @collection, options = {}) ->
    @viewTableRole = options.viewTableRole ? 'any'
    @editRole = options.editRole ? 'any'
    @exportTableRole = options.exportTableRole ? 'any'
    
    @useObjectIds = options.useObjectIds ? false
    
    @canEdit = options.canEdit ? true
    @formSchema = options.formSchema ? @sourceSchema

    @makeFormDataFetchMethodRunFkt = options.makeFormDataFetchMethodRunFkt
    @makeSubmitMethodRunFkt = options.makeSubmitMethodRunFkt
    @makeDeleteMethodRunFkt = options.makeDeleteMethodRunFkt
