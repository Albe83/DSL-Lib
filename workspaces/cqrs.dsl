workspace {
    name "CQRS"
    description "Describe Command and Queries Separetion Responsability Pattern"

    !identifiers hierarchical
    !impliedRelationships false

    model {
        properties {
            structurizr.groupSeparator "/"
        }

        group "CQRS System" {
            group "Server Subsystem" {
                group "Command Subsystem" {
                    commandService = softwareSystem "Resource Authoring Service" {
                        tags "Service" "Authoring"
                        tags "CQRS: Command" "CQRS" "Command"
                        
                        description "\
                            It is responsible to generate new resources, assigning a unique identifier.\
                            Also it is responsible to modify and remove already existing resources.\
                        "

                        broker = container "Message Broker" {
                            tags "Service" "Authoring"
                            tags "CQRS: Command" "CQRS" "Command"
                            tags "EDA: Broker" "EDA" "Broker"
                        }

                        controller = container "Command Controller" {
                            tags "Service" "Authoring"
                            tags "CQRS: Command" "CQRS" "Command"
                            tags "EDA: Producer" "EDA" "Producer"
                            tags "Controller"

                            -> broker "Publish" "CloudEvents"
                        }
                    }
                }
                
                group "Query Subsystem" {
                    fastService = softwareSystem "Fast Resource Reading Service" {
                        tags "Service" "Fast"
                        tags "CQRS: Query" "CQRS" "Query"

                        description "\
                            Provides a fast access to resources data.\
                            It is responsible for only a subset of resources.\
                        "

                        -> commandService "Watching resources events"

                        dataRepository = container "Data Repository" {
                            tags "Service" "Fast"
                            tags "CQRS: Query" "CQRS" "Query"
                            tags "Repository"
                        }

                        changesController = container "Changes Controller" {
                            tags "Service" "Fast"
                            tags "CQRS: Query" "CQRS" "Query"
                            tags "EDA: Consumer" "EDA" "Consumer"
                            tags "Controller"

                            -> dataRepository "Write"
                            -> commandService.broker "Consume" "CloudEvents"
                        }

                        evictionController = container "Eviction Controller" {
                            tags "Service" "Fast"
                            tags "CQRS: Query" "CQRS" "Query"
                            tags "Controller"

                            -> dataRepository "Delete"
                        }

                        queryController = container "Query Controller" {
                            tags "Service" "Fast"
                            tags "CQRS: Query" "CQRS" "Query"
                            tags "Controller"

                            -> dataRepository "Read"
                        }
                    }

                    archiveService = softwareSystem "Full Resource Reading Service" {
                        tags "Service" "Full"
                        tags "CQRS: Query" "CQRS" "Query"

                        description "\
                            Provides access to resources data.\
                            It is responsible for the full set of resources.\
                        "

                        -> commandService "Watching resources events"

                        dataRepository = container "Data Repository" {
                            tags "Service" "Full"
                            tags "CQRS: Query" "CQRS" "Query"
                            tags "Repository"
                        }

                        changesController = container "Changes Controller" {
                            tags "Service" "Full"
                            tags "CQRS: Query" "CQRS" "Query"
                            tags "EDA: Consumer" "EDA" "Consumer"
                            tags "Controller"

                            -> dataRepository "Write"
                            -> commandService.broker "Consume" "CloudEvents"
                        }

                        evictionController = container "Eviction Controller" {
                            tags "Service" "Full"
                            tags "CQRS: Query" "CQRS" "Query"
                            tags "Controller"

                            -> dataRepository "Delete"
                        }

                        queryController = container "Query Controller" {
                            tags "Service" "Full"
                            tags "CQRS: Query" "CQRS" "Query"
                            tags "Controller"

                            -> dataRepository "Read"
                        }
                    }
                }
            }

            group "Client Subsystem" {
                client = softwareSystem "Client" {
                    tags "Client"

                    description "\
                        A generic client using system to perform CRUD operations on resources.\
                    "
                    -> commandService "Performing create, edit and delete operations on resources."
                    -> fastService "Reading resources data from a selected subset."
                    -> archiveService "Reading resources data from the full set."

                    commandAdapter = container "Authoring Adapter" {
                        tags "Adapter"

                        -> commandService.controller
                    }

                    fastAdapter = container "Active Entities Adapter" {
                        tags "Adapter"

                        -> fastService.queryController
                    }

                    archiveAdapter = container "Archived Entities Adapter" {
                        tags "Adapter"

                        -> archiveService.queryController
                    }
                }
            }
        }

        deploymentEnvironment "NoProd Single Region" {
            deploymentNode "Clients" {
                instances "1"

                containerInstance client.commandAdapter
                containerInstance client.fastAdapter
                containerInstance client.archiveAdapter
            }

            deploymentNode "Region" {
                group "Command Service" {
                    deploymentNode "Command Controller" {
                        instances "1"
                        containerInstance commandService.controller
                    }

                    deploymentNode "Command Broker" {
                        instances "1"
                        containerInstance commandService.broker
                    }
                }

                group "Fast Query Service" {
                    deploymentNode "Fast Query Controller" {
                        instances "1"
                        containerInstance fastService.queryController
                    }

                    deploymentNode "Fast Changes Controller" {
                        instances "1"
                        containerInstance fastService.changesController
                    }

                    deploymentNode "Fast Eviction Controller" {
                        instances "1"
                        containerInstance fastService.evictionController
                    }

                    deploymentNode "Fast Data Repository" {
                        instances "1"
                        containerInstance fastService.dataRepository
                    }
                }

                group "Archive Query Service" {
                    deploymentNode "Archive Query Controller" {
                        instances "1"
                        containerInstance archiveService.queryController
                    }

                    deploymentNode "Archive Changes Controller" {
                        instances "1"
                        containerInstance archiveService.changesController 
                    }

                    deploymentNode "Archive Eviction Controller" {
                        instances "1"
                        containerInstance archiveService.evictionController
                    }

                    deploymentNode "Archive Data Repository" {
                        instances "1"
                        containerInstance archiveService.dataRepository
                    }
                }
            }
        }

        deploymentEnvironment "Production Single Region" {
            deploymentNode "Clients" {
                instances "1..N"

                containerInstance client.commandAdapter
                containerInstance client.fastAdapter
                containerInstance client.archiveAdapter
            }

            deploymentNode "Region" {
                group "Command Service" {
                    deploymentNode "Command Controller" {
                        instances "1..N"
                        containerInstance commandService.controller
                    }

                    deploymentNode "Command Broker" {
                        instances "3"
                        containerInstance commandService.broker
                    }
                }

                group "Fast Query Service" {
                    deploymentNode "Fast Query Controller" {
                        instances "1..N"
                        containerInstance fastService.queryController
                    }

                    deploymentNode "Fast Changes Controller" {
                        instances "1..2"
                        containerInstance fastService.changesController
                    }

                    deploymentNode "Fast Eviction Controller" {
                        instances "1"
                        containerInstance fastService.evictionController
                    }

                    deploymentNode "Fast Data Repository" {
                        instances "1..N"
                        containerInstance fastService.dataRepository
                    }
                }

                group "Archive Query Service" {
                    deploymentNode "Archive Query Controller" {
                        instances "1..N"
                        containerInstance archiveService.queryController
                    }

                    deploymentNode "Archive Changes Controller" {
                        instances "1..2"
                        containerInstance archiveService.changesController 
                    }

                    deploymentNode "Archive Eviction Controller" {
                        instances "1"
                        containerInstance archiveService.evictionController
                    }

                    deploymentNode "Archive Data Repository" {
                        instances "3"
                        containerInstance archiveService.dataRepository
                    }
                }
            }
        }

        deploymentEnvironment "Multiple Regions" {
            global = deploymentGroup "All Regions"
            region1 = deploymentGroup "Region 1"
            region2 = deploymentGroup "Region 2"

            deploymentNode "Clients" {
                instances "1..N"

                containerInstance client.commandAdapter region1,region2
                containerInstance client.fastAdapter region1,region2
                containerInstance client.archiveAdapter region1,region2
            }

            deploymentNode "Region 1" {
                group "Command Service" {
                    deploymentNode "Command Controller" {
                        instances "1..N"
                        containerInstance commandService.controller region1
                    }

                    deploymentNode "Command Broker" {
                        instances "3"
                        containerInstance commandService.broker region1,global
                    }
                }

                group "Fast Query Service" {
                    deploymentNode "Fast Query Controller" {
                        instances "1..N"
                        containerInstance fastService.queryController region1
                    }

                    deploymentNode "Fast Changes Controller" {
                        instances "1..2"
                        containerInstance fastService.changesController region1,global
                    }

                    deploymentNode "Fast Eviction Controller" {
                        instances "1"
                        containerInstance fastService.evictionController region1
                    }

                    deploymentNode "Fast Data Repository" {
                        instances "1..N"
                        containerInstance fastService.dataRepository region1
                    }
                }

                group "Archive Query Service" {
                    deploymentNode "Archive Query Controller" {
                        instances "1..N"
                        containerInstance archiveService.queryController region1
                    }

                    deploymentNode "Archive Changes Controller" {
                        instances "1..2"
                        containerInstance archiveService.changesController region1,global
                    }

                    deploymentNode "Archive Eviction Controller" {
                        instances "1"
                        containerInstance archiveService.evictionController region1
                    }

                    deploymentNode "Archive Data Repository" {
                        instances "3"
                        containerInstance archiveService.dataRepository region1
                    }
                }
            }

            deploymentNode "Region 2" {
                group "Command Service" {
                    deploymentNode "Command Controller" {
                        instances "1..N"
                        containerInstance commandService.controller region2
                    }

                    deploymentNode "Command Broker" {
                        instances "3"
                        containerInstance commandService.broker region2,global
                    }
                }

                group "Fast Query Service" {
                    deploymentNode "Fast Query Controller" {
                        instances "1..N"
                        containerInstance fastService.queryController region2
                    }

                    deploymentNode "Fast Changes Controller" {
                        instances "1..2"
                        containerInstance fastService.changesController region2,global
                    }

                    deploymentNode "Fast Eviction Controller" {
                        instances "1"
                        containerInstance fastService.evictionController region2
                    }

                    deploymentNode "Fast Data Repository" {
                        instances "1..N"
                        containerInstance fastService.dataRepository region2
                    }
                }

                group "Archive Query Service" {
                    deploymentNode "Archive Query Controller" {
                        instances "1..N"
                        containerInstance archiveService.queryController region2
                    }

                    deploymentNode "Archive Changes Controller" {
                        instances "1..2"
                        containerInstance archiveService.changesController region2,global
                    }

                    deploymentNode "Archive Eviction Controller" {
                        instances "1"
                        containerInstance archiveService.evictionController region2
                    }

                    deploymentNode "Archive Data Repository" {
                        instances "3"
                        containerInstance archiveService.dataRepository region2
                    }
                }
            }
        }
    }

    views {
        styles {
            themes default

            element "Controller" {
                shape "Hexagon"
            }

            element "EDA: Broker" {
                shape "Pipe"
            }

            element "Repository" {
                shape "Cylinder"
            }
        }

        systemLandscape "000-systemlandscape" {
            title "Structure: Big Picture"
            description "Highest-level view"

            autoLayout tb
            include *
            default
        }

        container commandService "010-command" {
            title "Structure: Authoring"
            description "How clients can create/delete and modify resources"

            autoLayout tb
            include ->element.parent==commandService->
            include element.tag==Repository->
        }

        container fastService "011-query" {
            title "Structure: Retriving Active Entities"
            description "How clients get informations on active resources using a fast interface"

            autoLayout tb
            include ->element.parent==fastService->
        }

        container archiveService "012-query" {
            title "Structure: Retriving Full Entities"
            description "How clients get informations on full resources using"

            autoLayout tb
            include ->element.parent==archiveService->
        }

        deployment * "NoProd Single Region" "201-deploy" {
            title "Deployment: No Production Single Region"
            description "Deployment in a no production environment on single region."

            autoLayout tb
            include *
        }

        deployment * "Production Single Region" "211-deploy" {
            title "Deployment: Production Single Region"
            description "Deployment in a production-ready environment on single region, when resilience and performance isn't a strong requirements."

            autoLayout tb
            include *
        }

        deployment * "Multiple Regions" "212-deploy" {
            title "Deployment: Multiple Regions"
            description "How deploy on two or more regions. Deployment for production with high performance and resilience requirements."
            
            autoLayout tb
            include *
        }
    }
}