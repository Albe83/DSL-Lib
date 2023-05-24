workspace "User Role" "A basic workspace with an Generic User Role" {
    !identifiers hierarchical
    
    !constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"
    
    !constant "userId" "mainUser"
    !constant "userId" "mainUser"
    !constant "userRole" "Main"
    !constant "userTitle" "${userRole} User"
    
    !constant "roleMainColor" "#1168bd"
    !constant "roleDarkenMainColor" "#083475"
    !constant "roleOffColor" "#ffffff"
    
    model {
      !include "${sharedDslPath}/user-role.dsl"
    }
    
    view {
      style {
        !include "${sharedDslPath}/styles/user-role.dsl"
      }
    }
}
