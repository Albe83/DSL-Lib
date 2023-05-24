workspace "User Role" "A basic workspace with an Generic User Role" {
    !identifiers hierarchical
    
    !constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"
    
    !constant "userId" "genericUser"
    !constant "userRole" "Generic"
    !constant "userTitle" "${userRole} User"
    
    !constant "roleMainColor" "grey"
    !constant "roleDarkenMainColor" "darkgrey"
    !constant "roleOffColor" "white"
    
    model {
      !include "${sharedDslPath}/user-role.dsl"
    }
    
    views {
      styles {
        !include "${sharedDslPath}/styles/user-role.dsl"
      }
    }
}
