-- ============================================================
-- Interactive Physics — Schema v4
-- Run AFTER physics_interactive_schema_v3.sql.
--
-- Adds diagram_key directly to physics_ip_questions, so a question
-- card itself can show a 2D illustration (not just explanation/example
-- steps). McqQuestion.jsx and FillBlankQuestion.jsx now render
-- <DiagramSlot diagramKey={question.diagram_key} /> right below the
-- prompt text.
--
-- Idempotent: IF NOT EXISTS throughout.
-- ============================================================

alter table physics_ip_questions
  add column if not exists diagram_key text;
