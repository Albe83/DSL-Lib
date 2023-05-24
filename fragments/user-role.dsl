/*
Usage:

!constant "sharedDslPath" "https://raw.githubusercontent.com/Albe83/DSL-Lib/main/fragments"

!constant "userId" "mainUser" //Element Identifier
!constant "userRole" "Main" // Role name
!constant "userTitle" "${userRole} User" //Element name
!include "${sharedDslPath}/user-role.dsl"
!ref "Person://${userTitle}" {
  description "The main reason the system exists."
}
*/

${userId} = person "${userTitle}" {
  tags "UserRole: ${userRole}"
  
  description "Please, provide a description of this user."
}
