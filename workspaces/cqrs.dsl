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
    }
}