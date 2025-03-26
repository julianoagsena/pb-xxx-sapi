%dw 2.0
output application/json
---
[ {
       	status: 1,
       	totPaginas: vars.responseCertificare.pagination.page default 0,
       	totRegistros: sizeOf(vars.responseCertificare.data.data filter ($."type" == "IfcEvent" and $.objectType == "Pendency")) default 0,
       	pendencias: flatten(vars.responseCertificare.*data map (item, index) -> 
                            (item.data filter ($."type" == "IfcEvent" and $.objectType == "Pendency") map (pendency) ->
                                            {
                                              		id: pendency.globalId,
                                              		numero: pendency.identification,
                                              		descricao: pendency.description,
                                              		status: ((item.data filter ($."type" == "IfcPropertySet" and $.definesOccurrence[0].ref == pendency.isDefinedBy[0].ref)).hasProperties[0] filter ($."name" == "Pendency_Status")).nominalValue.value[0],
                                              		dtCriacao: ((item.data filter ($."type" == "IfcPropertySet" and $.definesOccurrence[0].ref == pendency.isDefinedBy[0].ref)).hasProperties[0] filter ($."name" == "Pendency_Creation_Timestamp")).nominalValue.value[0] as DateTime,
                                              		unidadeOrganizacional: "",
                                              		grupo: (item.data filter($."type" == "IfcBuiltElement"  and ($.hasAssignments.ref contains pendency.operatesOn[0].ref))).name[0],
                                              		url: (item.data filter ($.relatingDocument."type" == "IfcDocumentReference" and (pendency.hasAssociations.ref contains $.globalId))).relatingDocument.location[0] default "",
                                              		documento: (item.data filter ($."type" == "IfcTask" and $.objectType == "Event" and ($.hasAssignments.ref contains pendency.operatesOn[0].ref))).name[0] default ""
                                           	})
) default []
    }]