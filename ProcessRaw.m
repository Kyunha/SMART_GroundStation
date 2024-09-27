function [P,F,T]=ProcessRaw(file, overlap, timeres, leakage, decimation)
            Fs=8e6;
            decimation=str2double(decimation);
            % Converter para complexo
            data = double(complex( file.Data(1:2:end) - mean(file.Data(1:2:end)), ...
                file.Data(2:2:end) - mean(file.Data(2:2:end)) ));
            Fc = str2double( extractBetween(file.Filename,'_f=','.bin'));
            data = downsample(data,decimation);
            
        
            try
                [P, F, T] = pspectrum(data, Fs/decimation, 'spectrogram', ...
                'OverlapPercent', overlap, ...
                'TimeResolution', timeres, ...
                'Leakage', leakage);
            catch
                P = 0;
                F = 0;
                T = 0;
                return;
            end

            F = (F/1e6)+Fc;
            P = rot90( pow2db(P) );

        end