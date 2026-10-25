import { redirect } from 'next/navigation';

export default async function LegacyRecordPage({
  searchParams,
}: {
  searchParams: Promise<{ eventId?: string }>;
}) {
  const params = await searchParams;
  const query = params?.eventId ? `?eventId=${params.eventId}` : '';
  redirect(`/ratechs-record${query}`);
}
