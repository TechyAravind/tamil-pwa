import { create } from 'zustand'
import { supabase } from '../supabase'

const useStore = create((set, get) => ({
  // ── Auth ──────────────────────────────────────
  session: null,
  setSession: (session) => set({ session }),

  // ── Sections & Topics ─────────────────────────
  sections: [],
  topics: {},        // keyed by sectionId
  sectionsLoaded: false,

  fetchSections: async () => {
    if (get().sectionsLoaded) return
    const { data, error } = await supabase
      .from('sections')
      .select('*')
      .order('order_index')
    if (!error) set({ sections: data, sectionsLoaded: true })
  },

  fetchTopicsForSection: async (sectionId) => {
    if (get().topics[sectionId]) return
    const { data, error } = await supabase
      .from('topics')
      .select('*')
      .eq('section_id', sectionId)
      .order('order_index')
    if (!error) set((s) => ({ topics: { ...s.topics, [sectionId]: data } }))
  },

  // ── Font size preference ───────────────────────
  fontSize: localStorage.getItem('fontSize') || 'medium',
  setFontSize: (size) => {
    localStorage.setItem('fontSize', size)
    set({ fontSize: size })
  }
}))

export default useStore
