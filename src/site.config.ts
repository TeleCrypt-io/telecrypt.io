export const plans = [
	{ name: "Free", price: "Free", storage: "No uploads", members: "1 account" },
	{ name: "Team", price: "25 EUR/month", storage: "5 GB shared storage", members: "Up to 3 users" },
	{ name: "Business", price: "59 EUR/month", storage: "25 GB shared storage", members: "Up to 10 users" },
	{ name: "Business+", price: "99 EUR/month", storage: "100 GB shared storage", members: "Up to 25 users" },
	{ name: "Max", price: "299 EUR/month", storage: "1 TB shared storage", members: "Up to 100 users" },
] as const;
// This is a production-only site. The host is fixed; there is no environment
// input and no stage www variant.
export const siteUrl = "https://www.telecrypt.io";
export const llmsUrl = "/llms.txt";
export const planUrl = "https://backend.telecrypt.io/plan/overview";

export const siteConfig = {
	author: "TeleCrypt.io",
	description:
		"End-to-end encrypted Matrix communication and shared file storage for human and artificial users.",
	lang: "en-US",
	ogLocale: "en_US",
	title: "TeleCrypt.io",
};

export const menuLinks: { path: string; title: string }[] = [
	{
		path: "/",
		title: "Index",
	},
	{
		path: "/price/",
		title: "Price",
	},
	{
		path: "/technology/",
		title: "Technology",
	},
	{
		path: "/about/",
		title: "About",
	},
	{
		path: "/support/",
		title: "Support",
	},
];
