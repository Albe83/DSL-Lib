!constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"

!constant "userId" "techUser"
!constant "userRole" "Tech"
!constant "userTitle" "Technical User"
!include "${sharedDslPath}/user-role.dsl"
!ref "Person://${userTitle}" {
  description "Performs maintenance activities on the system."
  
  !constant "styleUserRoleTechUserBackground" "#083475"
  !constant "styleUserRoleTechUserColor" "#ffffff"
  !constant "styleUserRoleTechUserStroke" "#1168bd"
}
