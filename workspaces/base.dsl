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
        }
    }
}
