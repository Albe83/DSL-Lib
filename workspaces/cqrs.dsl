workspace {
    name "CQRS"

    !identifiers hierarchical
    !impliedRelationships false

    model {
        properties {
            structurizr.groupSeparator "/"
        }

        group "CQRS System" {
            group "Server Subsystem" {
                group "Command Subsystem" {
                    commandService = softwareSystem "Authoring Service" {
                        tags "Service"
                        tags "CQRSCommand"

                        broker = container "Message Broker" {
                            tags "Broker"
                        }

                        controller = container "Command Controller" {
                            tags "Controller"

                            -> broker
                        }
                    }
                }
                
                group "Query Subsystem" {
                    fastService = softwareSystem "Active Entities Service" {
                        tags "Service"
                        tags "CQRSQuery"

                        dataRepository = container "Data Repository" {
                            tags "Repository"
                        }

                        changesController = container "Changes Controller" {
                            tags "Controller"

                            -> dataRepository
                            -> commandService.broker
                        }

                        evictionController = container "Eviction Controller" {
                            tags "Controller"

                            -> dataRepository
                        }

                        queryController = container "Query Controller" {
                            tags "Controller"

                            -> dataRepository
                        }
                    }

                    archiveService = softwareSystem "Archived Entities Service" {
                        tags "Service"
                        tags "CQRSQuery"

                        dataRepository = container "Data Repository" {
                            tags "Repository"
                        }

                        changesController = container "Changes Controller" {
                            tags "Controller"

                            -> dataRepository
                            -> commandService.broker
                        }

                        evictionController = container "Eviction Controller" {
                            tags "Controller"

                            -> dataRepository
                        }

                        queryController = container "Query Controller" {
                            tags "Controller"

                            -> dataRepository
                        }
                    }
                }
            }

            group "Client Subsystem" {
                client = softwareSystem "Client" {
                    tags "Client"

                    -> commandService
                    -> fastService
                    -> archiveService

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


        deploymentEnvironment "Single Region" {
            deploymentNode "Clients" {
                containerInstance client.commandAdapter
                containerInstance client.fastAdapter
                containerInstance client.archiveAdapter
            }

            deploymentNode "Region" {
                deploymentNode "Exection Platform" {
                    containerInstance commandService.controller

                    containerInstance fastService.changesController
                    containerInstance fastService.evictionController
                    containerInstance fastService.queryController

                    containerInstance archiveService.changesController
                    containerInstance archiveService.changesController
                    containerInstance archiveService.queryController 
                }

                deploymentNode "Message Platform" {
                    containerInstance commandService.broker
                }
                
                deploymentNode "RDBMS Platform" {
                    containerInstance archiveService.dataRepository
                }

                deploymentNode "K/V Platform" {
                    containerInstance fastService.dataRepository
                }
            }
        }

        deploymentEnvironment "Multiple Regions" {
            global = deploymentGroup "All Regions"
            region1 = deploymentGroup "Region 1"
            region2 = deploymentGroup "Region 2"

            deploymentNode "Clients" {
                containerInstance client.commandAdapter region1,region2
                containerInstance client.fastAdapter region1,region2
                containerInstance client.archiveAdapter region1,region2
            }

            deploymentNode "Region 1" {
                deploymentNode "Exection Platform" {
                    containerInstance commandService.controller region1

                    containerInstance fastService.changesController region1,global
                    containerInstance fastService.evictionController region1
                    containerInstance fastService.queryController region1

                    containerInstance archiveService.changesController region1,global
                    containerInstance archiveService.changesController region1
                    containerInstance archiveService.queryController region1
                }

                deploymentNode "Message Platform" {
                    containerInstance commandService.broker region1,global
                }
                
                deploymentNode "RDBMS Platform" {
                    containerInstance archiveService.dataRepository region1
                }

                deploymentNode "K/V Platform" {
                    containerInstance fastService.dataRepository region1
                }
            }

            deploymentNode "Region 2" {
                deploymentNode "Exection Platform" {
                    containerInstance commandService.controller region2

                    containerInstance fastService.changesController region2,global
                    containerInstance fastService.evictionController region2
                    containerInstance fastService.queryController region2

                    containerInstance archiveService.changesController region2,global
                    containerInstance archiveService.changesController region2
                    containerInstance archiveService.queryController region2
                }

                deploymentNode "Message Platform" {
                    containerInstance commandService.broker region2,global
                }
                
                deploymentNode "RDBMS Platform" {
                    containerInstance archiveService.dataRepository region2
                }

                deploymentNode "K/V Platform" {
                    containerInstance fastService.dataRepository region2
                }
            }
        }
    }

    views {
        styles {
            themes default

            element "Container" {
                shape "Hexagon"
            }

            element "Client" {
                shape "WebBrowser"
            }

            element "Service" {
                shape "Hexagon"
            }
            
            element "Broker" {
                shape "Pipe"
            }

            element "Repository" {
                shape "Cylinder"
            }
        }

        systemLandscape "systemLandscape" {
            title "Big Picture"
            description "Highest-level view"

            autoLayout tb
            include *
        }

        container commandService "Authoring" {
            title "Authoring"
            description "How clients can create/delete and modify resources"

            autoLayout tb
            include ->element.parent==commandService->
            include element.tag==Repository->
        }

        container fastService "FastQueries" {
            title "Retriving Active Entities"
            description "How clients get informations on active resources using a fast interface"

            autoLayout tb
            include ->element.parent==fastService->
        }

        container archiveService "ArchivedQueries" {
            title "Retriving Full Entities"
            description "How clients get informations on full resources using"

            autoLayout tb
            include ->element.parent==archiveService->
        }

        deployment * "Single Region" "deploy-001" {
            title "Single Region"
            description "How deploy on a single region. Deployment for no-production or low budget environments."

            autoLayout tb
            include *
        }

        deployment * "Multiple Regions" "deploy-002" {
            title "Multiple Regions"
            description "How deploy on two or more regions. Deployment for production with high performance and resilience requirements."
            
            autoLayout tb
            include *
        }
    }
}