workspace {
    name "User Role"
    description "A basic workspace with an Generic User Role"
    
    !identifiers hierarchical
    
    !constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"
    
    !constant "userId" "genericUser"
    !constant "userRole" "Generic"
    !constant "userTitle" "${userRole} User"
    
    !constant "userRoleMainColor" "grey"
    !constant "userRoleDarkenMainColor" "darkgrey"
    !constant "userRoleOffColor" "white"
    
    model {
      !include "${sharedDslPath}/user-role.dsl"
    }
    
    views {
      styles {
        !include "${sharedDslPath}/styles/user-role.dsl"
      }
    }
}
