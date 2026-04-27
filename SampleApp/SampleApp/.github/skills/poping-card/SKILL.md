# SKILL

## SwiftUI Card Requirement

Create a SwiftUI card component and use it consistently whenever a card is needed.

### Requirements

- Create a card with the specified aspect ratio.
- Take width as input and compute the card height from the ratio.
- Add these cards into an `HStack` with horizontal scrolling ability.
- Tapping on a card should play the video from the URL associated with that card.
- On long press, the card should "pop out" visually.
- When popped out, the card should display a play button inside it.
- While popped out, the card should also have a running border with an ambient color.

### Behavior

- The card width is configurable by input.
- The card height is derived from the desired ratio.
- Cards are arranged horizontally and scrollable.
- Each card is tied to a video URL.
- Tap gesture triggers playback for the associated video.
- Long press triggers a visual emphasis state:
  - card scales up or lifts
  - shows internal play button
  - animated coloured border appears

### Notes

- Use SwiftUI `ScrollView(.horizontal)` and `HStack` for layout.
- Use `GeometryReader` or a ratio-based `frame` modifier to maintain aspect ratio.
- Use `onTapGesture` for play action and `onLongPressGesture` for pop-out state.
- Use animation for smooth visual transitions.
- Use ambient colors for the running border to enhance the active state.
