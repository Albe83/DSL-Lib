workspace {
    !identifiers hierarchical
    !impliedRelationships false

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        
    views {
        styles {
            !constant "mainColor" "#1168bd"
            !constant "mainColorDarken" "#083475"
            
            !constant "offColor" "#ffffff"
            
            element "Element" {
                background "${mainColor}"
                color "${offColor}"
                stroke "${mainColorDarken}"
            }
            
            element "Person" {
                shape "Person"
            }
            
            element "Software System" {
              shape "RoundedBox"
            }
            
            element "Microservice" {
              shape "Hexagon"
            }
            
            element "Stateless" {
                background "${offColor}"
                color "${mainColor}"
                stroke "${mainColor}"
                border "dashed"
            }
            
            relationship "Relationship" {
                style "solid"
                color "${mainColor}"
            }
            
            relationship "Async" {
                style "dotted"
            }
            
            
            themes "https://static.structurizr.com/themes/kubernetes-v0.3/theme.json" "https://static.structurizr.com/themes/oracle-cloud-infrastructure-2023.04.01/theme.json" "https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json" "https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json" "https://structurizr.com/help/theme?url=https://static.structurizr.com/themes/google-cloud-platform-v1.5/theme.json"
        }
    }
}
