"use client";

import { useState } from "react";
import { ChevronDown, ChevronUp } from "lucide-react";
import { cn } from "@/lib/utils";

interface ExpandableHtmlProps {
  html: string;
  className?: string;
  maxHeight?: string;
}

export default function ExpandableHtml({ html, className, maxHeight = "384px" }: ExpandableHtmlProps) {
  const [expanded, setExpanded] = useState(false);

  return (
    <div className="flex flex-col">
      <div className="relative">
        <div 
          className={cn("overflow-hidden transition-all duration-500 ease-in-out", className)}
          style={{ maxHeight: expanded ? "5000px" : maxHeight }}
          dangerouslySetInnerHTML={{ __html: html }}
        />
        
        {!expanded && (
          <div className="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-slate-50 dark:from-slate-950 to-transparent pointer-events-none" />
        )}
      </div>
      
      <button
        onClick={() => setExpanded(!expanded)}
        className="mt-6 flex items-center justify-center gap-2 text-primary hover:text-primary/80 font-medium transition-colors w-full bg-primary/5 hover:bg-primary/10 py-2.5 rounded-xl border border-primary/10"
      >
        {expanded ? (
          <>
            Tutup <ChevronUp size={20} />
          </>
        ) : (
          <>
            Baca Selengkapnya <ChevronDown size={20} />
          </>
        )}
      </button>
    </div>
  );
}
