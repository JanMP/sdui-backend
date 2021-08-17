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
    rowsCollection, rowCountCollection
    listSchema
    getPreSelectPipeline
    getProcessorPipeline, getRowsPipeline, getRowCountPipeline, getExportPipeline
    debounceDelay
  } = definition


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
  
  # setup default props
  getPreSelectPipeline ?= -> []
  getProcessorPipeline ?= -> []

  listSchema ?= sourceSchema
  formSchema ?= sourceSchema

  listSchemaBridge = new SimpleSchema2Bridge(listSchema)
  formSchemaBridge =
    if listSchema is formSchema
      listSchemaBridge
    else
      new SimpleSchema2Bridge(formSchema)

  {defaultGetRowsPipeline
  defaultGetRowCountPipeline
  defaultGetExportPipeline} = createDefaultPipeline {getPreSelectPipeline, getProcessorPipeline, listSchema}

  getRowsPipeline ?= defaultGetRowsPipeline
  getRowCountPipeline ?= defaultGetRowCountPipeline
  getExportPipeline ?= defaultGetExportPipeline

  if Meteor.isClient # setup local collections for publications
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
    rowsCollection, rowCountCollection
    canEdit
    canSearch
    canAdd
    canDelete
    canExport
    viewTableRole
    editRole
    exportTableRole
  }