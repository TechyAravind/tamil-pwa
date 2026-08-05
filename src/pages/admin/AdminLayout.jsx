
import { Outlet, NavLink, useNavigate } from 'react-router-dom'
import { supabase } from '../../supabase'

const NAV = [
  { to: '/admin',            label: 'Dashboard',         exact: true },
  { to: '/admin/sections',   label: 'Sections (பகுதிகள்)' },
  { to: '/admin/topics',     label: 'Topics (தலைப்புகள்)' },
  { to: '/admin/pages',      label: 'Pages (பக்கங்கள்)' },
  { to: '/admin/prose',      label: 'Prose Content (உரை)' },
  { to: '/admin/poemlines',  label: 'Poem Lines (வரிகள்)' },
  { to: '/admin/morphemes',  label: 'Morphemes (சொல் பகுப்பு)' },
  { to: '/admin/verbanalysis', label: 'Verb Analysis (பகுபதம்)' },
  { to: '/admin/sandhirules', label: 'Sandhi Rules (புணர்ச்சி)' },
  { to: '/admin/literary',   label: 'Literary Notes (இலக்கிய நயம்)' },
  { to: '/admin/physics-groups',    label: 'Physics — Groups' },
  { to: '/admin/physics-chapters',  label: 'Physics — Chapters' },
  { to: '/admin/physics-subtopics', label: 'Physics — Subtopics' },
  { to: '/admin/physics-content',   label: 'Physics — Content' },
]

export default function AdminLayout() {
  const navigate = useNavigate()

  const handleLogout = async () => {
    await supabase.auth.signOut()
    navigate('/admin/login')
  }

  return (
    <div className="min-h-screen flex bg-gray-50">
      {/* Sidebar */}
      <aside className="w-64 bg-white border-r border-gray-100 flex flex-col shrink-0">
        <div className="p-4 border-b border-gray-100">
          <h1 className="font-bold text-primary text-lg">தமிழ் Admin</h1>
          <p className="text-xs text-gray-400">11ஆம் தமிழ்ப் பாடம்</p>
        </div>

        <nav className="flex-1 p-3 space-y-1 overflow-y-auto">
          {NAV.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.exact}
              className={({ isActive }) =>
                `admin-sidebar-link ${isActive ? 'active' : ''}`
              }
            >
              {item.label}
            </NavLink>
          ))}
        </nav>

        <div className="p-3 border-t border-gray-100">
          <button
            onClick={handleLogout}
            className="admin-sidebar-link w-full text-red-600 hover:bg-red-50 hover:text-red-700"
          >
            வெளியேறு (Logout)
          </button>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex-1 overflow-y-auto p-6">
        <Outlet />
      </main>
    </div>
  )
}
