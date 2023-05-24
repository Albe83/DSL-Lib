!constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"

!constant "userId" "supportiveUser"
!constant "userRole" "Supportive"
!constant "userTitle" "${userRole} User"
!include "${sharedDslPath}/user-role.dsl"
!ref "Person://${userTitle}" {
  description "Use the system to perform activities complementary to those of the primary users."
  
  !constant "styleUserRoleSupportiveUserBackground" "#ffffff"
  !constant "styleUserRoleSupportiveUserColor" "#1168bd"
  !constant "styleUserRoleSupportiveUserStroke" "#1168bd"
}
