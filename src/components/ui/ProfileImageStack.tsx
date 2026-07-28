'use client';

import { useState } from 'react';
import { cn } from '@/lib/utils';

export function ProfileImageStack() {
  const [topIndex, setTopIndex] = useState(2);

  const images = [
    {
      src: "/data/img1.jpg",
      baseClass: "-rotate-6 -translate-x-20 sm:-translate-x-32",
    },
    {
      src: "/data/img2.jpg",
      baseClass: "rotate-6 translate-x-20 sm:translate-x-32",
    },
    {
      src: "/data/img3.jpg",
      baseClass: "rotate-0",
    }
  ];

  return (
    <div className="flex-1 w-full aspect-square md:aspect-[4/3] relative flex items-center justify-center mt-8 lg:mt-0">
      {images.map((img, idx) => (
        <div
          key={idx}
          onMouseEnter={() => setTopIndex(idx)}
          className={cn(
            "absolute w-[65%] aspect-[4/3] rounded-3xl shadow-xl border-[4px] border-white dark:border-slate-900 bg-cover bg-center transition-all duration-700 ease-out cursor-pointer hover:rotate-0 hover:scale-110",
            img.baseClass,
            topIndex === idx ? "z-30 shadow-2xl" : "z-10"
          )}
          style={{ backgroundImage: `url('${img.src}')` }}
        />
      ))}
    </div>
  );
}
