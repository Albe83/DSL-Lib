/*
Usage:

!constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"

 //Element Identifier
!constant "userId" "mainUser"
// Role name
!constant "userRole" "Main"
 //Element name
!constant "userTitle" "${userRole} User"
!include "${sharedDslPath}/user-role.dsl"
!ref "Person://${userTitle}" {
  description "The main reason the system exists."
}

mailSystem -> mainUser "Send notifications"
*/

${userId} = person "${userTitle}" {
  tags "UserRole: ${userRole}"
  
  description "Please, provide a description of this user."
  
  // Styles
  !constant "styleRole${userId}MainColor" "${roleMainColor}"
  !constant "styleRole${userId}DarkenMainColor" "${roleDarkenMainColor}"
  !constant "styleRole${userId}OffColor" "${roleOffColor}"
}
