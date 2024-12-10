enum KycStatus {
  
  // fello account upgrade request is approved
  approved, 

  // fello account, but not yet upgrade
  notfound, 
  
  // fello account upgrade request waiting for approval
  requested, 
  
  // 
  pending,

  // fellow account upgrade request rejected
  rejected

}