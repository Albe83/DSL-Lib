!constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"

!constant "userId" "techUser"
!constant "userRole" "Tech"
!constant "userTitle" "Technical User"
!include "${sharedDslPath}/custom-user-role.dsl"
!ref "Person://${userTitle}" {
  description "Performs maintenance activities on the system."
}
