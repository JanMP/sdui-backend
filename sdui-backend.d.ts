declare module "meteor/janmp:sdui-backend"
{
  interface CreateAutoDataTableBackendProps {
    sourceName: String;
    sourceShema: SimpleSchema;
    collection: Mongo.Collection;
    useObjectIds?: boolean;
    viewTAbleRole?: string;
    canSearch?: boolean;
    canEdit?: boolean;
    formSchema: SimpleSchema;
    editRole?: string;
    canAdd?: boolean;
    canDelete?: boolean;
    canExport?: boolean;
    exportTableRole?: string;
    getPreSelectPipeline?: () => Array<object>;
    getProcessorPipeline?: () => Array<object>;
    getRowsPipeline?: () => Array<object>;
    getRowCountPipeline?: () => Array<object>;
    getExportPipeline?: () => Array<object>;
    rowsCollection: any
    rowCountCollection: any
    makeSubmitMethodRunFkt: any
    makeSubmitMethodRunFkt: any
    makeDeleteMethodRunFkt: any
    debounceDelay: number
  }

  export default function createAutoDataTableBackend(props: CreateAutoDataTableBackendProps): any
}