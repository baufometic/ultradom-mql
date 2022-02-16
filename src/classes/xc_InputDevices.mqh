class cKeystrokes {

	
	public:
		void Handler(int WhichKeyPressed) {
			ResetLastError();
 			Log.Write(__FUNCTION__);
 			
 			
 			
 			InterfaceMain.Update_LastKeyPressedLabel(Keystroke.GetDefinition(WhichKeyPressed) + " - " + Keystroke.GetFunction(WhichKeyPressed));
			
 			switch(WhichKeyPressed) {
 				case KEY_UP:	if (InterfaceIsActive[INTERFACE_STARTMENU]) {
 			               		InterfaceStartMenu.MoveUp();
 			               		return;
 			               	}
 			               	break;
               	
                	case KEY_DOWN:	if (InterfaceIsActive[INTERFACE_STARTMENU]) {
                					InterfaceStartMenu.MoveDown();
                					return;
                				}
                				break;
               				
                	case KEY_LEFT:	if (InterfaceIsActive[INTERFACE_MAIN]) {
                					//move active dom left
                				}
                				break;
               				
 				case KEY_RIGHT:if (InterfaceIsActive[INTERFACE_MAIN]) {
 								// move active dom right
 							}
 							break;  	
               	
                	case KEY_C:	if (InterfaceIsActive[INTERFACE_MAIN]) {
                					if (!InterfaceIsActive[INTERFACE_MATRIX]) {
                						Matrix.Create();
                					} else {
                						Matrix.Destroy();
                					}
                				}
                				break;
               					
               	
                	case KEY_J:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 								//InterfaceDOM.MovePointerDown();
 								return;
 							}
 							break;
							
 				case KEY_M:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 			               		//InterfaceDOM.MovePointerRight();
 			               		return;
 							}
 							break;
							
 				case KEY_N:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 			               		//InterfaceDOM.MovePointerLeft();
 			               		return;
                				}
                				break;
               				
                	case KEY_P:	break;
               	
                	case KEY_Q:	if (InterfaceIsActive[INTERFACE_PRESSSTART]) {
 								InterfacePressStart.Delete();
 								InterfaceStartMenu.Create();
 								return;
 							}
				
 							if (InterfaceIsActive[INTERFACE_STARTMENU]) {
 								if (StartMenuActiveItem == 0) {
 									InterfaceStartMenu.Delete();
 								     InterfaceAuthentication.Create();
 								} else if (StartMenuActiveItem == 1) {
 								     // do nothing
 								} else if (StartMenuActiveItem == 2) {     // CREDITS
 								     InterfaceHuman.Delete();
 								     InterfaceStartMenu.Delete();
 								     InterfaceCredits.Create();
 								}
 								return;
 							}
							
 							if (InterfaceIsActive[INTERFACE_CREDITS]) {
 								InterfaceCredits.Delete();
 								InterfaceHuman.Create();
 								InterfaceStartMenu.Create();
 								return;
 							}
							
 							break;
							
 				case KEY_R:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 								//Update_AllDOMPositions();
 							}
 							break;
							
 				case KEY_S:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 								//InterfaceDOM.RemoveRows();
 								return;
 							}
 							break;
							
 				case KEY_T:	break;
				
 				case KEY_U:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 								//InterfaceDOM.MovePointerUp();
 								return;
 							}
 							break;
							
 				case KEY_W:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 								//InterfaceDOM.InsertRows();
 								return;
 							}
 							break;
							
 				case KEY_X:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 			               		//InterfaceDOM.RemoveGrid();
 			               		return;
 			               	}
 			               	break;
			               	
 				case KEY_Z:	if (InterfaceIsActive[INTERFACE_MAIN]) {
 			               		//InterfaceDOM.AddGrid();
 			               		return;
 			               	}
 			               	break;
 			}
		}

		
};
cKeystrokes Keystrokes;

class cMouseClicks {
			
			if (InterfaceIsActive[INTERFACE_AUTHENTICATION]) {
				if ((WhichObject == AuthenticationSubmitShape) || (WhichObject == AuthenticationSubmitText)) {
					Log.Write("AUTH SUBMIT BUTTON PRESSED");
			
					if (InterfaceAuthentication.Authenticate()) {
						Log.Write("AUTHENTICATION SUCCEEDED");
						InterfaceIsActive[INTERFACE_STARTSCREEN] = false;
						Sounds.Sound("UltraDOM");
						InterfaceHuman.Delete();
						InterfaceMain.Create();
					} else {
						Log.Write("AUTHENTICATION FAILED");
					}
				}
			}
	
		}
};
cMouseClicks MouseClick;