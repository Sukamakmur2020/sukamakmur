'use client';

import React, { useState } from 'react';
import { RefreshCw } from 'lucide-react';
import { useRouter } from 'next/navigation';

export default function RefreshButton() {
  const router = useRouter();
  const [isRefreshing, setIsRefreshing] = useState(false);

  const handleRefresh = () => {
    setIsRefreshing(true);
    router.refresh();
    // Reset state after a short delay to allow for visual feedback
    setTimeout(() => {
      setIsRefreshing(false);
    }, 1000);
  };

  return (
    <button 
      onClick={handleRefresh}
      disabled={isRefreshing}
      className="p-2 rounded-lg text-slate-400 hover:text-primary hover:bg-primary/10 transition-colors disabled:opacity-50"
      title="Refresh Status"
    >
      <RefreshCw size={18} className={isRefreshing ? 'animate-spin text-primary' : ''} />
    </button>
  );
}
