#https://www.r-bloggers.com/creating-guis-in-r-with-gwidgets/
#https://www.rdocumentation.org/packages/gWidgets/versions/0.0-54

library(gWidgets)
library(gWidgetstcltk)

OnWindows = TRUE

if(OnWindows){
  setwd("//20X/LOL/R")
  lib_dir <- "//20X/LoL/Windows/library" #On Windows
}else{
  lib_dir <- "/usr/lib/R/library" #On Linux 
}

ROUND_VALUE <- 5
Data <- read.csv("info_gui.csv", header = TRUE, row.names=1, stringsAsFactors=FALSE)

Damage_Reduction <- function(Resistance, Penetration_Percent, Penetration_Flat){
  Resistance <- (Resistance - Resistance*Penetration_Percent) - Penetration_Flat
  if(Resistance > 0){
    Damage_Reduction = 100/(100+Resistance)
  } else{
    Damage_Reduction = 2-(100/(100-(Resistance)))
  }
  return(Damage_Reduction)
}
Lethality <- function(Level, Lethality){
  return(Lethality * (0.6+0.4*(Level/18)))
}
DamageBP <- function(D, B, P){
  return((D + D*B)*P)
}
CDR <- function(CD, CDR){
  return(CD - (CD*CDR))
}
Damages <- function(Build, Enemy_Info){
  Q = svalue(Q_Slider)
  W = svalue(W_Slider)
  E = svalue(E_Slider)
  R = svalue(R_Slider)
  
  R_Sc	 	= (0.1+(0.1*svalue(gp2_Level_Slider)))
  Y_Sc 		= (0.1+(0.1*svalue(gp2_Level_Slider)))
  B_Sc 		= (0.17+(0.17*svalue(gp2_Level_Slider)))
  P_Sc 		= (0.43+(0.43*svalue(gp2_Level_Slider)))
  
  R_Let = 1.6
  P_Let = 3.2
  
  R_ASc = (0.13+(0.13*svalue(gp2_Level_Slider)))
  Y_ASc = 0.06+(0.06*svalue(gp2_Level_Slider))
  B_ASc = 0.04+(0.04*svalue(gp2_Level_Slider))
  P_ASc = 0.25+(0.25*svalue(gp2_Level_Slider))
  
  R_AD    = 0.95
  Y_AD    = 0.43
  B_AD    = 0.28
  P_AD    = 2.25
  
  R_AP		= 0.59
  Y_AP 		= 0.59
  B_AP		= 1.19
  P_AP		= 4.95
  
  R_APFP 		= 0.87
  B_APFP 		= 0.63
  P_APFP 		= 2.01
  
  B_CDR_Sc = (0.09+(0.09*svalue(gp2_Level_Slider)))/100
  P_CDR_Sc = (0.28+(0.28*svalue(gp2_Level_Slider)))/100
  Stack = 1

  Stats 	<- c()
  for(i in (1:length(Build))){
    for(col in (1:ncol(Data[Build[i],]))){
      Data[Build[i], col] <- eval(parse(text=Data[Build[i], col]))
    }
    Stats 	<- c(Stats, as.numeric(as.vector(Data[Build[i],])))
  }
  
  Stats <- array(Stats, dim = c(21, length(Stats)/21, 1))
  Magic_Damage_Reduction_Percent <- c(Stats[2,,])
  Attack_Damage_Reduction_Percent <- c(Stats[6,,])
  Stats <- apply(Stats, c(1), sum)
  Stats <- array(Stats, dim = c(21, 1, 1))
  
  Damage_Modifiers 	<- c((1-0.03), (1-.02), (1-0.02))
  Total_Damage		<- 0
  
  if("Karthus" %in% Build){
    Magic_Damage_Reduction_Percent <- c(Magic_Damage_Reduction_Percent, c(1-0.15))
  }
  
  Magic_Damage_Reduction_Percent <- Magic_Damage_Reduction_Percent[Magic_Damage_Reduction_Percent != 0]
  Magic_Damage_Reduction_Percent <- 1-(prod(Magic_Damage_Reduction_Percent))
  Stats[2] <- Magic_Damage_Reduction_Percent
  
  Attack_Damage_Reduction_Percent <- Attack_Damage_Reduction_Percent[Attack_Damage_Reduction_Percent != 0]
  Attack_Damage_Reduction_Percent <- 1-(prod(Attack_Damage_Reduction_Percent))
  Stats[6] <- Attack_Damage_Reduction_Percent
  
  Magic_Damage_Reduction	= Damage_Reduction(Enemy_Info[3], Stats[2], Stats[3])
  
  Attack_Damage_Reduction	= Damage_Reduction(Enemy_Info[2], Stats[6], Lethality(Enemy_Info[1], Stats[7]))
  
  if(Stats[16] > 0.40){
    Stats[16] <- 0.4
  }
  if("Seraphs_Embrace" %in% Build){
    Stats[1] 		<- Stats[1] + (Stats[12]*0.03)
  }
  if("Rabadons_Deathcap" %in% Build){
    Stats[1] 		<- Stats[1] + (Stats[1]*0.35)
  }
  if("Abyssal_Mask" %in% Build){
    Damage_Modifiers 	<- c(Damage_Modifiers, c(1-0.10))
  }
  
  Stats[10] 	<- Stats[10]+((Stats[10]*Stats[11])/100)
  Stats[20]	<- Stats[20]+((Stats[20]*Stats[19])/100)
  
  Damage_Modifier 	<- 1-(prod(Damage_Modifiers))
  
  CSB <- 2
  if("Infinity_Edge" %in% Build){
    CSB <- CSB + 0.5
  }
  if("Ludens_Echo" %in% Build){
    Ludens_Echo_Damage	<- DamageBP(100+Stats[1]*0.10, Damage_Modifier, Magic_Damage_Reduction)
    Total_Damage 	<- Total_Damage + Ludens_Echo_Damage
  }
  if("Liandrys_Torment" %in% Build){
    Liandrys_Torment_Damage	<- DamageBP(Enemy_Info[4]*0.04, Damage_Modifier, Magic_Damage_Reduction)
    Total_Damage 		<- Total_Damage + Liandrys_Torment_Damage
  }
  if(TRUE %in% grepl("Ferocity", Build)){
    Keystone = "Deathfire Grasp"
    #Deathfire_Grasp	<- DamageBP(4+Stats[1]*0.125 + Stats[5]*0.225, Damage_Modifier, Magic_Damage_Reduction)
    Deathfire_Grasp	<- DamageBP(4+Stats[1]*0.125 + Stats[5]*0.225, Damage_Modifier, Magic_Damage_Reduction)
    Total_Damage 	<- Total_Damage + Deathfire_Grasp
  }
  if("Cunning" %in% Build){
    Keystone = "Thunderlord's Decree"
    Thunderlords_Decree	<- DamageBP((10*svalue(gp2_Level_Slider))+Stats[5]*0.30 + Stats[1]*0.10, Damage_Modifier, Magic_Damage_Reduction)
    Total_Damage 	<- Total_Damage + Thunderlords_Decree
  }
  DM <- Damage_Modifier
  MDR <- Magic_Damage_Reduction
  ADR <- Attack_Damage_Reduction
  if("Jhin" %in% Build){
    Bonus_AD  <- 0.02
    Bonus_AD  <- Bonus_AD + (Stats[9] %/% 0.1 * 0.04)
    Bonus_AD  <- Bonus_AD + (Stats[11] %/% 0.1 * 0.025)
    for(x in 1:svalue(gp2_Level_Slider)){
      if(x < 11){
        Bonus_AD <- Bonus_AD + 0.01
      }else{
        Bonus_AD <- Bonus_AD + 0.04
      }
    }
    
    Stats[5]  <- Stats[5] + (Stats[5] * Bonus_AD)
    A1_CDR    <- CDR(7-(0.5*Q), Stats[16])
    A2_CDR    <- CDR(14, Stats[16])
    A3_CDR    <- CDR(28, Stats[16])
    A4_CDR    <- CDR(120-(15*R), Stats[16])
    
    A1        <- DamageBP(45+(25*Q) + Stats[1]*0.60 + (Stats[5]*(0.40+0.05*Q)), DM, ADR)
    A2        <- DamageBP(50+(35*W) + Stats[5]*0.50, DM, ADR)
    A3        <- DamageBP(20+(60*E) + Stats[1]*1.0 + Stats[5]*1.2, DM, MDR)
    A4        <- DamageBP(50+(65*R) + Stats[5]*0.2, DM, ADR)
  }
  if("Xerath" %in% Build){
    A1_CDR		<- CDR(9-(1*Q), Stats[16])
    A2_CDR		<- CDR(14-(1*W), Stats[16])
    A3_CDR		<- CDR(13-(0.5*E), Stats[16])
    A4_CDR		<- CDR(130-(15*R), Stats[16])
    
    
    A1             	<- DamageBP(80+(40*Q) + (Stats[1]*0.75), Damage_Modifier, Magic_Damage_Reduction)
    A2_Perimeter   	<- DamageBP(60+(30*W) + (Stats[1]*0.60), Damage_Modifier, Magic_Damage_Reduction)
    A2      		<- DamageBP(90+(45*W) + (Stats[1]*0.90), Damage_Modifier, Magic_Damage_Reduction)
    A3             	<- DamageBP(80+(30*E) + (Stats[1]*0.45), Damage_Modifier, Magic_Damage_Reduction)
    A4     		<- DamageBP(200+(40*R)+ (Stats[1]*0.43), Damage_Modifier, Magic_Damage_Reduction)
    A4_Multiple   	<- A4*5
    
  }
  
  if("Karthus" %in% Build){
    A1_CDR		<- CDR(1, Stats[16])
    A2_CDR		<- CDR(18, Stats[16])
    A3_CDR		<- 1
    A4_CDR		<- CDR(200-(20*R), Stats[16])
    
    A1			<- DamageBP( 40+(20*Q)+Stats[1]*0.30, 	Damage_Modifier, Magic_Damage_Reduction)
    A2			<- DamageBP( 0, 			Damage_Modifier, Magic_Damage_Reduction)
    A3			<- DamageBP( 30+(20*E)+Stats[1]*0.20, 	Damage_Modifier, Magic_Damage_Reduction)
    A4			<- DamageBP( 250+(150*R)+Stats[1]*0.60, Damage_Modifier, Magic_Damage_Reduction)
  }
  
  if(Q == -1){
    A1 = 0
  }
  if(W == -1){
    A2 = 0
  }
  if(E == -1){
    A3 = 0
  }
  if(R == -1){
    A4 = 0
  }
  
  Attack_Speed  <- 
    Basic_Damage	<- Total_Damage + A1 + A2 + A3
  Total_Combo		<- Total_Damage + (A1 + A2 + A3 + A4)
  
  A1_DPS		<- A1/A1_CDR
  A2_DPS		<- A2/A2_CDR
  A3_DPS		<- A3/A3_CDR
  A4_DPS		<- A4/A4_CDR
  
  AS <- Stats[10]+(Stats[10]*Stats[11])
  
  if("Jhin" %in% Build){
    CSB <- CSB - 0.25
    AS <- Stats[10]
  }
  
  AA <- DamageBP(Stats[5]*CSB, DM, ADR)
  abilities 		<- c(AA, AS, A1, A1_DPS, A2, A2_DPS, A3, A3_DPS, A4, A4_DPS, Stats[1], Stats[5], Basic_Damage, Damage_Modifier, ADR, MDR, Total_Combo)
  damages 		<- array(c(abilities), dim = c(17, 1, 1))
  return(damages)
}

Enemy_Info = c(6,100,100,1500)
Champion = "Xerath"

AP00		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap")
AP01		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap", "Void_Staff", "Liandrys_Torment", "Ludens_Echo")
AP02		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap", "Void_Staff", "Liandrys_Torment", "Ludens_Echo")
AP03		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap", "Void_Staff", "Liandrys_Torment", "Ludens_Echo")
AP04		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap", "Void_Staff", "Liandrys_Torment", "Ludens_Echo")

AP05		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap", "Void_Staff", "Liandrys_Torment", "Ludens_Echo")
AP06		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap", "Void_Staff", "Liandrys_Torment", "Ludens_Echo")
AP07		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap", "Void_Staff", "Liandrys_Torment", "Ludens_Echo")
AP08		<- c("Dorans_Ring", "Morellonomicon", "Rabadons_Deathcap", "Void_Staff", "Liandrys_Torment", "Ludens_Echo")

AP1		<- c("Seraphs_Embrace", "Rabadons_Deathcap", "Mejais_Soul_Stealer", 	"Void_Staff", "Liandrys_Torment", "Sorcerers_Shoes")
AP2		<- c("Seraphs_Embrace", "Rabadons_Deathcap", "Mejais_Soul_Stealer", 	"Void_Staff", "Liandrys_Torment", "Ludens_Echo")
AP3		<- c("Seraphs_Embrace", "Rabadons_Deathcap", "Ludens_Echo", "Void_Staff", "Liandrys_Torment", "Sorcerers_Shoes")
AP4		<- c("Seraphs_Embrace", "Rabadons_Deathcap", "Morellonomicon", "Void_Staff", "Ludens_Echo", "Sorcerers_Shoes")
AP5		<- c("Seraphs_Embrace", "Rabadons_Deathcap", "Mejais_Soul_Stealer",		"Void_Staff", "Liandrys_Torment", "Ludens_Echo")
AP6		<- c("Seraphs_Embrace", "Rabadons_Deathcap", "Mejais_Soul_Stealer",	  "Void_Staff", "Ludens_Echo", "Morellonomicon")
AP7		<- c("Rabadons_Deathcap", "Liandrys_Torment", "Ludens_Echo", "Sorcerers_Shoes", "Morellonomicon", "Void_Staff")
AP8		<- c("Rabadons_Deathcap", "Liandrys_Torment", "Ludens_Echo", "Sorcerers_Shoes", "Morellonomicon", "Banshees_Veil")

AD0		<- c("Long_Sword")
AD1		<- c("Lord_Dominiks_Regards", "Essence_Reaver", "Youmuus_Ghostblade", "Berserkers_Greaves", "Infinity_Edge", "Phantom_Dancer")
AD2		<- c("Lord_Dominiks_Regards", "Essence_Reaver", "Youmuus_Ghostblade", "Berserkers_Greaves", "Infinity_Edge", "Phantom_Dancer")
AD3		<- c("Lord_Dominiks_Regards", "Essence_Reaver", "The_Bloodthirster", "Berserkers_Greaves", "Infinity_Edge", "Phantom_Dancer")
AD4		<- c("Lord_Dominiks_Regards", "Edge_of_Night", "Youmuus_Ghostblade", "Berserkers_Greaves", "Infinity_Edge", "Phantom_Dancer")
AD5		<- c("Lord_Dominiks_Regards", "Edge_of_Night", "Youmuus_Ghostblade", "Berserkers_Greaves", "Infinity_Edge", "Essence_Reaver")
AD6		<- c("Lord_Dominiks_Regards", "Edge_of_Night", "Youmuus_Ghostblade", "Phantom_Dancer", "Infinity_Edge", "Essence_Reaver")


Items1		<- AP2
Items2		<- AP2
Items3		<- AP2
Items4		<- AP2

Runes1		<- c("Mage")
Runes2		<- c("Mage_2")
Runes3		<- c("Mage_3")
Runes4		<- c("Mage_Scaling")
Runes5		<- c("Magic_Penetration")
Runes6		<- c("Mage_Flat")
Runes7		<- c("Mage_Farm")
Runes8		<- c("Full_Scaling")

Masteries1			<- c("Ferocity_AP")
Masteries2			<- c("Cunning")


Build1		<<- c(Items1, Champion, Runes1, Masteries1)
Build2		<<- c(Items2, Champion, Runes2, Masteries1)
Build3		<<- c(Items3, Champion, Runes3, Masteries1)
Build4		<<- c(Items4, Champion, Runes4, Masteries1)



win <- gwindow("Table")

gp_Build <- ggroup(container=win)



gp1_Items <- ggroup(container=win)
gp2_Stats <- ggroup(container=win)

#gp3_Output <- ggroup(container=win, use.scrollwindow = FALSE, horizontal = TRUE)


gp4_ItemSets <- ggroup(horizontal = TRUE, container=win)

gp_Runes <- gedit(
  text = "Runes", 
  container = gp_Build,
  handle = function(h, ...)
  {
    svalue(gp_Runes) <- UpdateItem(svalue(gp_Runes), svalue(ItemSetSelector), 8)  
  }
)

gp_Masteries <- gedit(
  text = "Masteries", 
  container = gp_Build,
  handle = function(h, ...)
  {
    svalue(gp_Masteries) <- UpdateItem(svalue(gp_Masteries), svalue(ItemSetSelector), 9)  
  }
)

UpdateItem <- function(ItemInput, ItemSet, ItemNumber){
  if(TRUE %in% is.na(Data[ItemInput,])){
    return("INVALID ITEM")
  }else{
    CE1 <- sprintf('Build%s[%s] <<- "%s"', ItemSet, ItemNumber, ItemInput)
    CE2 <- sprintf('svalue(gp4_ItemSet%s) <- Build%s', ItemSet, ItemSet)
    eval(parse(text = CE1))
    eval(parse(text = CE2))
    UpdateTable()
    return("Item Updated")
  }
}

gp1_i1 <- gedit(
  text = "Item1", 
  container = gp1_Items,
  handle = function(h, ...)
  {
    svalue(gp1_i1) <- UpdateItem(svalue(gp1_i1), svalue(ItemSetSelector), 1)
  }
)
gp1_i2 <- gedit(
  text = "Item2", 
  container = gp1_Items,
  handle = function(h, ...)
  {
    svalue(gp1_i2) <- UpdateItem(svalue(gp1_i2), svalue(ItemSetSelector), 2)  
  }
)
gp1_i3 <- gedit(
  text = "Item3", 
  container = gp1_Items,
  handle = function(h, ...)
  {
    svalue(gp1_i3) <- UpdateItem(svalue(gp1_i3), svalue(ItemSetSelector), 3)  
  }
)
gp1_i4 <- gedit(
  text = "Item4", 
  container = gp1_Items,
  handle = function(h, ...)
  {
    svalue(gp1_i4) <- UpdateItem(svalue(gp1_i4), svalue(ItemSetSelector), 4)  
  }
)
gp1_i5 <- gedit(
  text = "Item5", 
  container = gp1_Items,
  handle = function(h, ...)
  {
    svalue(gp1_i5) <- UpdateItem(svalue(gp1_i5), svalue(ItemSetSelector), 5)  
  }
)
gp1_i6 <- gedit(
  text = "Item6", 
  container = gp1_Items,
  handle = function(h, ...)
  {
    svalue(gp1_i6) <- UpdateItem(svalue(gp1_i6), svalue(ItemSetSelector), 6)  
  }
)



gp2_Champion <- gedit(
  text = "Champion", 
  container = gp_Build,
  handle = function(h, ...)
  {
    svalue(gp2_Champion) <- UpdateItem(svalue(gp2_Champion), svalue(ItemSetSelector), 7)  
  }
)

gp2_Level <- glabel("Level", container = gp2_Stats)
gp2_Level_Slider <- gslider(
  from = 0, 
  to = 17, 
  by = 1, 
  value = 17, 
  container=gp2_Stats,
  handler = function(h, ...)
  {
    UpdateTable()
    svalue(gp2_Level) <- as.character(svalue(gp2_Level_Slider))
  }
)

Q_Label <- glabel("Q", container = gp2_Stats)
Q_Slider <- gslider(
  from = -1, 
  to = 4, 
  by = 1, 
  value = 4, 
  container=gp2_Stats,
  handler = function(h, ...)
  {
    #UpdateTable()
    svalue(Q_Label) <- as.character(svalue(Q_Slider))
  }
)

W_Label <- glabel("W", container = gp2_Stats)
W_Slider <- gslider(
  from = -1, 
  to = 4, 
  by = 1, 
  value = 4, 
  container=gp2_Stats,
  handler = function(h, ...)
  {
    #UpdateTable()
    svalue(W_Label) <- as.character(svalue(W_Slider))
  }
)
E_Label <- glabel("E", container = gp2_Stats)
E_Slider <- gslider(
  from = -1, 
  to = 4, 
  by = 1, 
  value = 4, 
  container=gp2_Stats,
  handler = function(h, ...)
  {
    #UpdateTable()
    svalue(E_Label) <- as.character(svalue(E_Slider))
  }
)
R_Label <- glabel("R", container = gp2_Stats)
R_Slider <- gslider(
  from = -1, 
  to = 4, 
  by = 1, 
  value = 4, 
  container=gp2_Stats,
  handler = function(h, ...)
  {
    #UpdateTable()
    svalue(R_Label) <- as.character(svalue(R_Slider))
  }
)

UpdateStats <- function(){
  a1 <<- Damages(Build1, Enemy_Info)
  a2 <<- Damages(Build2, Enemy_Info)
  a3 <<- Damages(Build3, Enemy_Info)
  a4 <<- Damages(Build4, Enemy_Info)
  
  
  #cat(sprintf("a1: %s\na2: %s\na3: %s\na4: %s\n\n\n", a1, a2, a3, a4))
  row.names 		<- c("Auto Attack", "AA DPS", "Q", "Q DPS", "W", "W DPS", "E", "E DPS", "R", "R DPS", "AP", "AD", "Basic Damage", "Damage Modifier", "ADR", "MDR", "Total Damage")
  row.height		<- length(row.names)
  
  Comparisons <- c(row.names,a1,a2,a3,a4)
  col.width     <- length(Comparisons)/row.height
  column.names 		<- c(as.character(1:col.width))
  matrix.names 		<- c("Main")
  Comparisons <- array(Comparisons, dim = c(row.height, col.width, 1), dimnames = list(row.names, column.names, matrix.names))
  return(Comparisons)
}
UpdateTable <- function(){
  gp3_gtable[] <- UpdateStats()
}

gp3_gtable <- gtable(UpdateStats(), container=win)

btnRefresh <- gbutton(
  "Refresh", 
  container=gp_Build,
  handler = function(h, ...)
  {
    gp3_gtable[] <- UpdateStats()
  }
)

ItemSetSelector <- gcombobox(
  c(1,2,3,4),
  selected = 1,
  container = gp_Build
)

gp4_ItemSet1 <- glabel(text = Build1, container=gp4_ItemSets)
gp4_ItemSet2 <- glabel(text = Build2, container=gp4_ItemSets)
gp4_ItemSet3 <- glabel(text = Build3, container=gp4_ItemSets)
gp4_ItemSet4 <- glabel(text = Build4, container=gp4_ItemSets)
