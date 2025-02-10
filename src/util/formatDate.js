/* 
 * Accept string containing a date in YYYY-MM-DD format or
 * an object with {year:YYYY, month:MM, day:DD}
 * Return date as MM/DD/YYYY string 
 * Assumes UTC (Z) for all dates
 * Reject [], [{object}], "", {}, null, "non-date-string" as "Date Unknown"
 */
import dayjs from 'dayjs';

export function formatDate(date) {
  if (date !== undefined && date !== null && (typeof date === "object" || typeof date === "string")) {
    if (typeof date === "object" && Object.keys(date).length > 0) {
      date = [String(date?.month ?? ''), String(date?.day ?? ''), String(date?.year ?? '')].join('/');
    }
    return dayjs(date).isValid() ? dayjs(date).format("MM/DD/YYYY") : "Date Unknown";
  } else {return "Date Unknown"}
}


