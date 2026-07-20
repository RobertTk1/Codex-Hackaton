# Chat-First Generative Onboarding Research

Status: Applied to v2 redesign  
Date: 2026-07-19

## Sources reviewed

- [Google: What is conversation design?](https://developers.google.com/assistant/conversation-design/what-is-conversation-design)
- [Google: Learn about conversation and turn-taking](https://developers.google.com/assistant/conversation-design/learn-about-conversation)
- [Google: Conversational lists](https://developers.google.com/assistant/conversation-design/list)
- [Vercel: AI SDK Generative UI](https://vercel.com/blog/ai-sdk-3-generative-ui)
- [CopilotKit: Human-in-the-loop](https://docs.copilotkit.ai/agent-spec/human-in-the-loop)
- [Lemonade annual report: AI Maya onboarding](https://www.sec.gov/Archives/edgar/data/1691421/000169142122000015/lmnd-20211231.htm)

## What the rejected pass got wrong

It preserved the original form logic, placed those forms inside oversized message containers, and added a permanent summary/progress sidebar. The result was form-first with chat decoration—not a conversational experience.

Google’s guidance is explicit: a working GUI cannot simply receive text or voice and become conversational; the interaction logic must be redesigned from the bottom up. It also recommends a single question per turn and warns against presenting several questions after handing the user the turn.

## Applied principles

### 1. One turn, one question

Each state has one obvious question. The assistant asks it, yields, and waits. It does not pair age, height, weight, and preference controls in one component.

### 2. Text first

Name, gender, age, height, optional weight, desired styling help, brands, categories, and sizes are collected through the composer as natural-language answers. Gender uses that exact term, may be self-described, and includes the approved styling/shopping-purpose language. The system may offer two or three short suggestion chips, but never a card grid where ordinary text is enough.

Examples:

- “How old are you?” → `28`
- “What would you like help styling?” → `Work outfits and complete weekend looks.`
- “Which brand fits you best?” → `COS — usually M in tops and 30 in trousers.`

### 3. UI only when it earns its place

Generative UI appears inline only for interactions that are materially better visually or require a trusted control:

- photo upload and photo-quality recovery;
- visual Love / Hate / Maybe calibration;
- Google or email magic-link account access; and
- the final factual confirmation before report generation.

This follows the generative-UI model described by Vercel: move beyond plain text by rendering purpose-built interactive components for a specific tool/result, not by turning every response into a component.

### 4. Pause and resume

The assistant pauses when a contextual component appears and resumes only after the customer responds. This matches the human-in-the-loop pattern: the workflow keeps context while the person keeps control.

### 5. Minimal chrome

- Narrow centered conversation column.
- Magic Mirror wordmark in a quiet top bar.
- Small progress label or six unobtrusive dots; no sidebar, dashboard, or profile rail.
- Prior turns remain in the transcript but reduce in visual weight.
- Persistent bottom composer is the center of gravity.

### 6. High-impact questions only

Lemonade describes its Maya onboarding as using a limited number of high-impact questions and adapting based on answers. Magic Mirror should combine information naturally when the user provides it and skip redundant follow-ups.

### 7. Smoothness rules

- The user message appears immediately after send.
- A brief, specific confirmation carries context forward; no repeated summary after every turn.
- The next question streams into the thread without fake typing theater.
- The view scrolls so the new question and composer remain together.
- Errors stay in the relevant turn and never clear prior answers.
- `Back` edits the most recent answer; transcript answers can be selected to reopen that turn.
- Keyboard focus returns to the composer after each completed turn.
- Mobile keeps the composer above the keyboard and uses the full screen as conversation space.

## New visual target

The experience should resemble a calm private conversation in an editorial studio: mostly typography, restrained alternating messages, generous white space, one active moment, and the occasional rich component arriving exactly when it helps. It should not resemble a settings wizard, dashboard, survey, or support-chat widget.
