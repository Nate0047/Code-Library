# Template for adding colourbrewer to plots
ggplot(<df>, aes(x = <data>, fill = <data>)) +
  geom_bar(show.legend = FALSE) +
  scale_colour_brewer(palette = "<insert desired pallet>",
                      aesthetics = "fill",
                      na.value = "grey") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 0),
        panel.border = element_blank(),
        strip.background = element_blank()) +
  ylab("<axis title>") +
  xlab("<axis title>")