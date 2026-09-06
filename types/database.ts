export type Role = 'adoptante' | 'refugio'
export interface Profile { id:string; full_name:string; role:Role; city:string|null; created_at:string }
export interface Pet { id:string; owner_id:string; name:string; species:string; breed:string; age:number; city:string; description:string; image_url:string; status:'disponible'|'en_proceso'|'adoptado'; created_at:string; profiles?:Pick<Profile,'full_name'> }
export interface Application { id:string; pet_id:string; applicant_id:string; message:string; status:'pendiente'|'aprobada'|'rechazada'; created_at:string; pets?:Pick<Pet,'name'|'image_url'>; profiles?:Pick<Profile,'full_name'> }
