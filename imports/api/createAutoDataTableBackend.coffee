import publishTableData from './publishTableData'
import createTableDataMethods from './createTableDataMethods'
import createDefaultPipeline from './createDefaultPipeline'
import SimpleSchema2Bridge from 'uniforms-bridge-simple-schema-2'


export default createAutoDataTableBackend = (definition) ->
  {
    viewTableRole
    editRole
    exportTableRole
    sourceName, sourceSchema, collection
    useObjectIds
    canEdit, formSchema,
    makeFormDataFetchMethodRunFkt, makeSubmitMethodRunFkt, makeDeleteMethodRunFkt
    canSearch
    canAdd
    canDelete
    canExport
    usePubSub
    rowsCollection, rowCountCollection
    listSchema
    getPreSelectPipeline
    pipelineMiddle, getProcessorPipeline, getRowsPipeline, getRowCountPipeline, getExportPipeline
    redrawTrigger,
    debounceDelay
  } = definition

  if redrawTrigger?
    console.warn 'redrawTrigger is not supported anymore'

  unless sourceName?
    throw new Error 'no sourceName given'

  unless sourceSchema?
    throw new Error 'no sourceSchema given'

  unless viewTableRole?
    viewTableRole = 'any'
    console.warn "[createAutoDataTableBackend #{sourceName}]: no viewTableRole defined for AutoDataTableBackend #{sourceName}, using '#{viewTableRole}' instead."

  if canEdit and not editRole?
    editRole = viewTableRole
    console.warn "[createAutoDataTableBackend #{sourceName}]: no editRole defined for AutoDataTableBackend #{sourceName}, using '#{editRole}' instead."

  if canExport and not exportTableRole?
    exportTableRole = viewTableRole
    console.warn "[createAutoDataTableBackend #{sourceName}]: no exportTableRole defined for AutoDataTableBackend #{sourceName}, using '#{exportTableRole}' instead."

  if pipelineMiddle?
    console.warn "[createAutoDataTableBackend #{sourceName}]: pipelineMiddle is deprecated. Please use getProcessorPipeline"
  
  getPreSelectPipeline ?= -> []
  getProcessorPipeline ?= -> pipelineMiddle ? []

  listSchema ?= sourceSchema
  formSchema ?= sourceSchema

  listSchemaBridge = new SimpleSchema2Bridge(listSchema)
  if listSchema is formSchema
    formSchemaBridge = listSchemaBridge
  else
    formSchemaBridge = new SimpleSchema2Bridge(formSchema)

  {defaultGetRowsPipeline
  defaultGetRowCountPipeline
  defaultGetExportPipeline} = createDefaultPipeline {getPreSelectPipeline, getProcessorPipeline, listSchema}

  getRowsPipeline ?= defaultGetRowsPipeline
  getRowCountPipeline ?= defaultGetRowCountPipeline
  getExportPipeline ?= defaultGetExportPipeline

  if usePubSub
    if Meteor.isClient
      rowsCollection ?= new Mongo.Collection "#{sourceName}.rows"
      rowCountCollection ?= new Mongo.Collection "#{sourceName}.count"
    
    publishTableData {
      viewTableRole, sourceName, collection,
      getRowsPipeline, getRowCountPipeline, debounceDelay
    }

  createTableDataMethods {
    viewTableRole, editRole, exportTableRole, sourceName, collection, useObjectIds,
    getRowsPipeline, getRowCountPipeline, getExportPipeline
    canEdit, canDelete, canExport, formSchema, makeFormDataFetchMethodRunFkt, makeSubmitMethodRunFkt
  }


  #return props for the ui component
  {
    sourceName, listSchemaBridge, formSchemaBridge
    usePubSub, rowsCollection, rowCountCollection
    canEdit
    canSearch
    canAdd
    canDelete
    canExport
    viewTableRole
    editRole
    exportTableRole
  }