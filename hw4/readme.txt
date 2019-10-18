There is UINavigationController with two UIViewControllers.

1.
NavigationRootViewController has heartButton and repairButton that can be tapped. 
If heartButton is tapped then MyViewController becomes visible.
If heartButton is disabled you should use repairButton to make it enabled.

2.
MyViewController has also two button with titles: "Остаться навсегда"(1) and "Уйти"(2).
If (2) is tapped then NavigationRootViewController becomes visible. 
If (10 is tapped then you will see Sunrise animation. 
In order to go back to NavigationRootViewController you need to change the orientation of your device to landscape mode and then switch to portrait mode again. This action will change button title to "Уйти". And if you tap it now you will go to NavigationRootViewController.
