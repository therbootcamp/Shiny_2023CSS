

prop = injuries %>% 
  left_join(products) %>% 
  filter(age <= 18) %>% 
  mutate(age_group = case_when(
    age <= 2 ~ "0-2",
    age > 2 & age <= 4 ~ "3-4",
    age > 4 & age <= 7 ~ "5-7",
    age > 7 & age <= 10 ~ "8-10",
    age > 10 & age <= 14 ~ "11-14",
    age > 14 & age <= 18 ~ "15-18") %>% 
      factor(levels = c("0-2","3-4","5-7","8-10","11-14","15-18"))) %>% 
  group_by(age_group, diag, title) %>% 
  summarize(n = log(n())) %>% 
  group_by(age_group) %>% 
  mutate(f = n/sum(n))

p = prop %>% 
  ggplot(aes(x = diag, y = title, fill = f)) +
  geom_tile() + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1),
        axis.title = element_blank()) +
  facet_wrap(~age_group) +
  theme(legend.position = "none") +
  scale_fill_viridis_c(option = "G")

ggsave("~/Downloads/NEISS.pdf", plot = p, 
       device = "pdf", width = 16, height = 10)



prop = injuries %>% 
  left_join(products) %>% 
  filter(age <= 18) %>% 
  mutate(age_group = case_when(
    age <= 2 ~ "0-2",
    age > 2 & age <= 4 ~ "3-4",
    age > 4 & age <= 7 ~ "5-7",
    age > 7 & age <= 10 ~ "8-10",
    age > 10 & age <= 14 ~ "11-14",
    age > 14 & age <= 18 ~ "15-18") %>% 
      factor(levels = c("0-2","3-4","5-7","8-10","11-14","15-18"))) %>% 
  group_by(age_group, diag, title) %>% 
  summarize(n = (n())**.3) %>% 
  group_by(age_group) %>% 
  mutate(f = n/sum(n))

p = prop %>% 
  ggplot(aes(x = diag, y = title, fill = f)) +
  geom_tile() + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1),
        axis.title = element_blank()) +
  facet_wrap(~age_group) +
  theme(legend.position = "none") +
  scale_fill_viridis_c(option = "G")

ggsave("~/Downloads/NEISS.pdf", plot = p, 
       device = "pdf", width = 16, height = 10)




ns = injuries %>% 
  left_join(products) %>% 
  filter(age <= 18) %>% 
  mutate(age_group = case_when(
    age <= 2 ~ "0-2",
    age > 2 & age <= 4 ~ "3-4",
    age > 4 & age <= 7 ~ "5-7",
    age > 7 & age <= 10 ~ "8-10",
    age > 10 & age <= 14 ~ "11-14",
    age > 14 & age <= 18 ~ "15-18") %>% 
      factor(levels = c("0-2","3-4","5-7","8-10","11-14","15-18"))) %>% 
  group_by(age_group, diag, title) %>% 
  summarize(n = n()) 

diag_sel = ns %>% 
  group_by(diag) %>% 
  summarize(n = sum(n)) %>% 
  filter(n > 1000) %>% 
  pull(diag)

title_sel = ns %>% 
  group_by(title) %>% 
  summarize(n = sum(n)) %>% 
  filter(n > 1000) %>% 
  pull(title)

diag_levels = ns %>% 
  filter(age_group == "0-2", 
         diag %in% diag_sel) %>% 
  group_by(diag) %>% 
  summarize(n = sum(n)) %>% 
  arrange(desc(n)) %>% 
  pull(diag)

title_levels = ns %>% 
  filter(age_group == "0-2",
         title %in% title_sel) %>% 
  group_by(title) %>% 
  summarize(n = sum(n)) %>% 
  arrange((n)) %>% 
  pull(title)



prop = ns %>%
  filter(diag %in% diag_sel,
         title %in% title_sel) %>% 
  mutate(diag = factor(diag, diag_levels),
         title = factor(title, title_levels)) %>% 
  ungroup() %>% 
  complete(age_group, diag, title) %>% 
  mutate(across(everything(), ~replace_na(.x, 0))) %>% 
  group_by(age_group) %>% 
  mutate(n = (n)**.3,
         f = n/sum(n, na.rm=T)) %>% 
  ungroup()

p = prop %>% 
  ggplot(aes(x = diag, y = title, fill = f)) +
  geom_tile() + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 1),
        axis.title = element_blank()) +
  facet_wrap(~age_group) +
  theme(legend.position = "none") +
  scale_fill_viridis_c(option = "G")

p

ggsave("~/Downloads/NEISS_sel.pdf", plot = p, 
       device = "pdf", width = 12, height = 10)



