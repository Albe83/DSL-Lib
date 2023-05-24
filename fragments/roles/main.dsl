!constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"

!constant "userId" "mainUser"
!constant "userRole" "Main"
!constant "userTitle" "${userRole} User"
!include "${sharedDslPath}/user-role.dsl"
!ref "Person://${userTitle}" {
  description "The main reason the system exists."
}
