"use client";

import React, { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { LayoutDashboard, Users, Map, FileText, Newspaper, Building2, Inbox, Settings, Menu, X } from 'lucide-react';
import AdminLogout from '@/components/admin/AdminLogout';
import { cn } from '@/lib/utils';

export default function AdminLayoutClient({ children }: { children: React.ReactNode }) {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const pathname = usePathname();

  const toggleMenu = () => setIsMobileMenuOpen(!isMobileMenuOpen);
  const closeMenu = () => setIsMobileMenuOpen(false);

  const menuItems = [
    { href: '/admin', icon: LayoutDashboard, label: 'Dashboard' },
    { href: '/admin/profile', icon: Building2, label: 'Profil Desa' },
    { href: '/admin/infografis', icon: Users, label: 'Infografis' },
    { href: '/admin/katalog', icon: Map, label: 'Katalog' },
    { href: '/admin/berita', icon: Newspaper, label: 'Berita' },
    { href: '/admin/ppid', icon: FileText, label: 'PPID' },
    { href: '/admin/inbox', icon: Inbox, label: 'Kotak Masukan' },
  ];

  return (
    <div className="flex h-screen w-full bg-slate-50 dark:bg-slate-950 overflow-hidden font-sans relative">
      {/* Mobile Overlay */}
      {isMobileMenuOpen && (
        <div 
          className="fixed inset-0 bg-black/50 z-20 md:hidden" 
          onClick={closeMenu}
        />
      )}

      {/* Sidebar */}
      <aside className={cn(
        "fixed md:static inset-y-0 left-0 w-64 bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800 flex flex-col z-30 transition-transform duration-300 transform md:translate-x-0",
        isMobileMenuOpen ? "translate-x-0" : "-translate-x-full"
      )}>
        <div className="h-16 flex items-center justify-between px-6 border-b border-slate-200 dark:border-slate-800 shrink-0">
          <div className="flex items-center">
            <div className="w-8 h-8 rounded-lg bg-primary flex items-center justify-center mr-3 text-white font-bold">W</div>
            <span className="text-lg font-bold text-slate-900 dark:text-white">CMS</span>
          </div>
          <button onClick={closeMenu} className="md:hidden text-slate-500 hover:text-slate-900 dark:hover:text-white">
            <X size={20} />
          </button>
        </div>
        
        <nav className="flex-1 overflow-y-auto py-6 px-3 space-y-1.5">
          <div className="px-3 mb-2 text-xs font-semibold text-slate-400 uppercase tracking-wider">Menu Utama</div>
          
          {menuItems.map((item) => {
            const isActive = pathname === item.href || (item.href !== '/admin' && pathname?.startsWith(item.href + '/'));
            return (
              <Link 
                key={item.href}
                href={item.href}
                onClick={closeMenu}
                className={cn(
                  "flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors font-medium",
                  isActive 
                    ? "bg-primary text-white" 
                    : "text-slate-700 dark:text-slate-300 hover:bg-primary/10 hover:text-primary"
                )}
              >
                <item.icon size={18} />
                {item.label}
              </Link>
            )
          })}
        </nav>
        
        <div className="p-4 border-t border-slate-200 dark:border-slate-800 shrink-0 flex flex-col gap-2">
          <Link 
            href="/admin/pengaturan"
            onClick={closeMenu}
            className={cn(
              "flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors font-medium",
              pathname === '/admin/pengaturan' || pathname?.startsWith('/admin/pengaturan/')
                ? "bg-primary text-white" 
                : "text-slate-700 dark:text-slate-300 hover:bg-primary/10 hover:text-primary"
            )}
          >
            <Settings size={18} />
            Pengaturan Akun
          </Link>
          <AdminLogout />
        </div>
      </aside>
      
      {/* Main Content Area */}
      <main className="flex-1 flex flex-col overflow-hidden relative">
        <header className="h-16 flex items-center justify-between px-4 md:px-8 bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-800 z-10 shrink-0">
          <div className="flex items-center gap-3">
            <button onClick={toggleMenu} className="md:hidden text-slate-500 hover:text-slate-900 dark:hover:text-white p-2 -ml-2">
              <Menu size={24} />
            </button>
            <h1 className="text-lg md:text-xl font-bold text-slate-800 dark:text-slate-100 tracking-tight line-clamp-1">Panel Administrasi</h1>
          </div>
          <div className="flex items-center gap-4 shrink-0">
            <div className="flex items-center gap-3 cursor-pointer p-1.5 rounded-full hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors">
              <span className="text-sm font-semibold hidden sm:block text-slate-700 dark:text-slate-300">Admin Desa</span>
              <div className="w-9 h-9 rounded-full bg-primary text-white flex items-center justify-center font-bold shadow-sm shadow-primary/20 shrink-0">
                A
              </div>
            </div>
          </div>
        </header>
        
        <div className="flex-1 overflow-auto p-4 md:p-8 relative z-0">
          <div className="max-w-6xl mx-auto">
            {children}
          </div>
        </div>
      </main>
    </div>
  );
}
