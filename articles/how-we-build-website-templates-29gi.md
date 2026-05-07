---
title: "How we build website templates"
url: "https://dev.to/shreyvijayvargiya/how-we-build-website-templates-29gi"
author: "Shrey Vijayvargiya"
category: "templatized-software"
---
# How we build website templates
**Author:** Shrey Vijayvargiya  **Published:** November 7, 2025

## Overview
The article explains a practical approach to building modern website templates using Next.js and React, discussing structuring projects to handle multiple simultaneous builds and rapid product launches.

## Key Concepts
- **Technology Stack**: React/Next.js, JSX, Tailwind CSS, react-icons, lucide-react, Vercel
- **Standard Template Pages**: Landing page, About, Blogs, Blog detail, Subscribe, Legal, Contact, Services, Dashboards, Pricing, Login/Sign-up
- **Landing Page Structure**: Navbar, Hero, About, Features/Services, Testimonials, Pricing, FAQs, Contact Form, Footer
- **Design & Animation**: Framer-motion, GSAP or anime.js, Tailwind responsive breakpoints (sm, md, lg, xl, 2xl)
- **File Organization**: Component-based section architecture with file-based routing

```jsx
import { ArrowRight } from "lucide-react";
import { motion } from "framer-motion";

const HeroSection = ({ onOpenLogin }) => {
  return (
    <motion.section
      initial={{ opacity: 0, y: 50 }}
      whileInView={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6 }}
    >
      {/* Content */}
    </motion.section>
  );
};

export default HeroSection;
```

```jsx
"use client";

import { useState } from "react";
import Link from "next/link";
import { ArrowRight, Calendar, Clock } from "lucide-react";

const titleToSlug = (title) => {
  return title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
};

const BlogsPage = () => {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  return (
    <div className="relative w-full h-full bg-black min-h-screen">
      {/* Layout */}
    </div>
  );
};

export default BlogsPage;
```

```jsx
import { Heater } from "lucide-react";
import Link from "next/link";
import { navigationItems } from "../constants";

const Footer = () => {
  return (
    <footer className="relative w-full bg-gradient-to-r from-black to-zinc-950 border-t border-zinc-800 z-10">
      {/* Footer content */}
    </footer>
  );
};

export default Footer;
```

Demo: http://eternal-landing-page.vercel.app/
Template Store: https://www.gettemplate.website/premium-templates
