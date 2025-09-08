import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

export const posts = defineCollection({
    loader: glob({pattern: '**/*.md(x)?', base: './src/content/posts'}),
    schema: z.object({
        title: z.string(),
        description: z.string().optional(),
        draft: z.boolean().default(false),
        pubDate: z.date(),
        author: z.string().default("While True Mate"),
        tags: z.array(z.string()).optional(),
        image: z.string().optional(),
    }),
});
