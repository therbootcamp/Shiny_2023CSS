# Lower Arm
# Lower Trunk
# Head
# Hand
# Knee
# Lower Leg
# Toe
# Shoulder
# Finger
# Elbow
# N.S./Unk
# Eyeball
# Wrist
# Upper Arm
# Ankle
# Foot
# Face
# Neck
# All Of Body
# Mouth
# Pubic Region
# Ear
# Internal
# Upper Leg
# 25 - 50% Body

body = read_csv("~/Downloads/body", col_names = F)
nose = read_csv("~/Downloads/nose", col_names = F)
shoulder_points = read_csv("~/Downloads/shoulder_points", col_names = F)
pubic_point = read_csv("~/Downloads/pubic", col_names = F)
pubic_point[1,2] = pubic_point[1,2] + 100

eyes1 = (t(t(ellipse::ellipse(x = 0,npoints = 20, scale = c(20, 12))) + c(740, max(body[,2])-3910))) %>% as_tibble() %>% rename(X1 = x, X2 = y)
eyes2 = (t(t(ellipse::ellipse(x = 0,npoints = 20, scale = c(20, 12))) + c(900, max(body[,2])-3910))) %>% as_tibble() %>% rename(X1 = x, X2 = y)
face = (t(t(ellipse::ellipse(x = 0,npoints = 20, scale = c(68, 80))) + c(820, max(body[,2])-3880)))  %>% as_tibble() %>% rename(X1 = x, X2 = y)
mouth = (t(t(ellipse::ellipse(x = 0,npoints = 20, scale = c(40, 20))[c(18:20,1:8),]) + c(820, max(body[,2])-3785))) %>% as_tibble() %>% rename(X1 = x, X2 = y)

shoulder1 = rbind(body[106:111,], shoulder_points[2,])
shoulder2 = rbind(body[154:159,], shoulder_points[1,])
lowertrunk = rbind(body[224:232,], body[17:26,])
foot1 = rbind(body[275:286,], body[1:6,])
ankle1 = rbind(body[275:276,], body[5:6,])
toes1 = rbind(body[279:286,], body[1:3,])
lowerleg1 = rbind(body[270:275,], body[6:12,])
knee1 = rbind(body[269:270,], body[12:13,])
upperleg1 = rbind(body[266:269,], body[13:17,])
pubic = rbind(body[232,],pubic_point, body[17,])
upper_trunk = rbind(body[223:224,], body[26:27,], shoulder_points[2,], body[111:115,], body[152:154,], shoulder_points[1,])
head = rbind(body[117:149,])
neck = rbind(body[149:152,],body[115:117,])
upperarm1 = rbind(body[102:106,],shoulder_points[2,],body[27:29,])
elbow1 = rbind(body[100:102,],body[29:31,])
hand1 = rbind(body[38:93,])
wrist1 = rbind(body[93:94,], body[37:38,])
lowerarm1 = rbind(body[94:100,],body[31:37,])
finger1 = rbind(body[43:89,])
upperarm2 = rbind(body[220:223,],shoulder_points[1,], body[159:163,])
elbow2 = rbind(body[218:220,],body[163:165,])
lowerarm2 = rbind(body[214:218,],body[165:170,])
hand2 = rbind(body[171:213,])
wrist2 = rbind(body[213:214,], body[170:171,])

finger2 = rbind(body[175:211,])
foot2 = rbind(body[242:257,])
toes2 = rbind(body[245:254,])
ankle2 = rbind(body[256:257,], body[242:243,])
lowerleg2 = rbind(body[237:242,], body[257:262,])
knee2 = rbind(body[262:263,], body[236:237,])
upperleg2 = rbind(body[232:236,], body[263:266,])
ears1 = rbind(body[140:146,])
ears2 = rbind(body[122:127,])
gesamt = tibble(X1 = c(300, 200, 200, 300, 300),
                X2 = c(3000, 3000, 3140, 3140, 3000))
twenty_five = tibble(X1 = c(300, 200, 200, 300, 300),
                     X2 = c(3000, 3000, 3140, 3140, 3000) + 200)
unbekannt = tibble(X1 = c(300, 200, 200, 300, 300),
                     X2 = c(3000, 3000, 3140, 3140, 3000) + 600)
internal = tibble(X1 = c(300, 200, 200, 300, 300),
                   X2 = c(3000, 3000, 3140, 3140, 3000) + 400)

body_tbl = tibble() %>% 
  bind_rows(body %>% mutate(part = "Silhouette", id = "silhouette")) %>% 
  bind_rows(gesamt %>% mutate(part = "Gesamter Körper", id = "gesamter_körper")) %>% 
  bind_rows(twenty_five %>% mutate(part = "25-50% des Körpers", id = "zwanzig_fünfzig_körper")) %>% 
  bind_rows(eyes1 %>% mutate(part = "Augapfel", id = "auge_1")) %>%   
  bind_rows(eyes2 %>% mutate(part = "Augapfel", id = "auge_2")) %>%   
  bind_rows(elbow1 %>% mutate(part = "Ellbogen", id = "ellbogen_1")) %>%   
  bind_rows(elbow2 %>% mutate(part = "Ellbogen", id = "ellbogen_2")) %>%   
  bind_rows(finger1 %>% mutate(part = "Finger", id = "finger_1")) %>%   
  bind_rows(finger2 %>% mutate(part = "Finger", id = "finger_2")) %>%   
  bind_rows(foot1 %>% mutate(part = "Fuss", id = "fuss_1")) %>%   
  bind_rows(foot2 %>% mutate(part = "Fuss", id = "fuss_2")) %>%   
  bind_rows(ankle1 %>% mutate(part = "Fussgelenk", id = "fussgelenk_1")) %>%   
  bind_rows(ankle2 %>% mutate(part = "Fussgelenk", id = "fussgelenk_2")) %>% 
  bind_rows(face %>% mutate(part = "Gesicht", id = "gesicht")) %>% 
  bind_rows(neck %>% mutate(part = "Hals", id = "hals")) %>%   
  bind_rows(wrist1 %>% mutate(part = "Handgelenk", id = "handgelenk_1")) %>%   
  bind_rows(wrist2 %>% mutate(part = "Handgelenk", id = "handgelenk_2")) %>%   
  bind_rows(internal %>% mutate(part = "Intern", id = "intern")) %>%   
  bind_rows(knee1 %>% mutate(part = "Knie", id = "knie_1")) %>%   
  bind_rows(knee2 %>% mutate(part = "Knie", id = "knie_2")) %>% 
  bind_rows(head %>% mutate(part = "Kopf", id = "kopf")) %>% 
  bind_rows(mouth %>% mutate(part = "Mund", id = "mund")) %>% 
  bind_rows(unbekannt %>% mutate(part = "Nicht bekannt", id = "nicht_bekannt")) %>% 
  bind_rows(upperarm1 %>% mutate(part = "Oberarm", id = "oberarm_1")) %>% 
  bind_rows(upperarm2 %>% mutate(part = "Oberarm", id = "oberarm_2")) %>% 
  bind_rows(upper_trunk %>% mutate(part = "Oberer Oberkörper", id = "oberer_oberkörper")) %>% 
  bind_rows(upperleg1 %>% mutate(part = "Oberschenkel", id = "oberschenkel_1")) %>% 
  bind_rows(upperleg2 %>% mutate(part = "Oberschenkel", id = "oberschenkel_2")) %>% 
  bind_rows(ears1 %>% mutate(part = "Ohr", id = "ohr_1")) %>% 
  bind_rows(ears2 %>% mutate(part = "Ohr", id = "ohr_2")) %>% 
  bind_rows(pubic %>% mutate(part = "Schamgegend", id = "schamgegend")) %>% 
  bind_rows(shoulder1 %>% mutate(part = "Schulter", id = "schulter_1")) %>% 
  bind_rows(shoulder2 %>% mutate(part = "Schulter", id = "schulter_2")) %>% 
  bind_rows(lowerarm1 %>% mutate(part = "Unterarm", id = "unterarm_1")) %>% 
  bind_rows(lowerarm2 %>% mutate(part = "Unterarm", id = "unterarm_2")) %>% 
  bind_rows(lowertrunk %>% mutate(part = "Unterer Oberkörper", id = "unterer_oberkörper")) %>% 
  bind_rows(lowerleg1 %>% mutate(part = "Unterschenkel", id = "unterschenkel_1")) %>% 
  bind_rows(lowerleg2 %>% mutate(part = "Unterschenkel", id = "unterschenkel_2")) %>% 
  bind_rows(toes1 %>% mutate(part = "Zehen", id = "zehen_1")) %>% 
  bind_rows(toes2 %>% mutate(part = "Zehen", id = "zehen_2")) %>% 
  bind_rows(hand1 %>% mutate(part = "Hand", id = "hand_1")) %>% 
  bind_rows(hand2 %>% mutate(part = "Hand", id = "hand_2")) %>%  
  rename(x = X1, y = X2, körperteil = part) %>% 
  mutate(körperteil = factor(körperteil, 
                             levels = c("Silhouette","Oberer Oberkörper", "Unterarm", "Unterer Oberkörper", "Kopf", 
                             "Hand", "Knie", "Unterschenkel", "Schulter", "Finger", 
                             "Nicht bekannt", "Oberarm", "Fuss", "Hals", 
                             "Gesamter Körper", "Intern", "Schamgegend",
                             "Oberschenkel", "25-50% des Körpers",
                             "Gesicht", "Ohr", "Fussgelenk", "Zehen", "Handgelenk", "Ellbogen", "Mund",
                             "Augapfel")),
         id = factor(id, 
                     levels = c("silhouette", "gesamter_körper", "zwanzig_fünfzig_körper", 
                     "fuss_1", "fuss_2", "fussgelenk_1", "fussgelenk_2", "hals", 
                     "intern", "knie_1", "knie_2", "kopf", 
                     "nicht_bekannt", "oberarm_1", "oberarm_2", "oberer_oberkörper", 
                     "oberschenkel_1", "oberschenkel_2", "ohr_1", "ohr_2", "schulter_1","schulter_2", 
                     "unterarm_1", "unterarm_2", "unterer_oberkörper", "unterschenkel_1", 
                     "unterschenkel_2", "gesicht", "mund", "zehen_1", "zehen_2", "hand_1", "hand_2", "auge_2", 
                     "auge_1","handgelenk_1", "handgelenk_2", "schamgegend",
                     "ellbogen_1", "ellbogen_2", "finger_1", "finger_2"))) %>% 
  mutate(y = 4160.112 - y)
  
  
# cat(paste0('"',unique(verletzungen$körperteil),'",'), sep=" ")
# cat(paste0('"',unique(body_tbl$id),'",'), sep=" ")

saveRDS(body_tbl %>% filter(körperteil != "Silhouette"), 
          "1_data/körper.RDS")

  
  